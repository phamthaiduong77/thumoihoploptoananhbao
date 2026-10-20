-- TRƯỚC KHI CHẠY: tạo user Admin trong Authentication > Users, sao chép UUID,
-- rồi thay MỌI chỗ YOUR_ADMIN_USER_UUID bên dưới bằng UUID thật.
-- Sau đó chạy toàn bộ file trong Supabase Dashboard > SQL Editor.
-- Tắt public sign-ups trong Supabase Auth; chỉ tạo tài khoản Admin do bạn kiểm soát.

create table if not exists public.site_settings (
  id integer primary key check (id = 1),
  organizer text not null default 'Lớp Toán anh Bảo',
  title text not null default 'Thư mời Lễ gặp mặt',
  description text not null default 'Sự hiện diện của bạn là niềm vui của chúng tôi.',
  event_time text not null default 'Tối Chủ nhật',
  event_location text not null default 'Sẽ được cập nhật',
  updated_at timestamptz not null default now()
);

create table if not exists public.rsvps (
  id bigint generated always as identity primary key,
  guest_name text not null check (char_length(trim(guest_name)) between 1 and 100),
  attendance text not null check (attendance in ('yes', 'no')),
  guest_count integer not null default 1 check (guest_count between 1 and 5),
  message text check (message is null or char_length(message) <= 500),
  created_at timestamptz not null default now()
);

insert into public.site_settings (id)
values (1)
on conflict (id) do nothing;

alter table public.site_settings enable row level security;
alter table public.rsvps enable row level security;

-- Xóa các policy mẫu cùng tên nếu chạy lại script.
drop policy if exists "Public can read invitation settings" on public.site_settings;
drop policy if exists "Admin can update invitation settings" on public.site_settings;
drop policy if exists "Public can submit RSVP" on public.rsvps;
drop policy if exists "Admin can read RSVP" on public.rsvps;

-- Khách chưa đăng nhập chỉ đọc được nội dung công khai của thiệp.
create policy "Public can read invitation settings"
on public.site_settings for select
to anon, authenticated
using (true);

-- Chỉ UUID Admin được chỉnh sửa thiệp.
create policy "Admin can update invitation settings"
on public.site_settings for update
to authenticated
using (auth.uid() = 'YOUR_ADMIN_USER_UUID'::uuid)
with check (auth.uid() = 'YOUR_ADMIN_USER_UUID'::uuid);

-- Khách có thể gửi RSVP nhưng không được đọc danh sách phản hồi.
create policy "Public can submit RSVP"
on public.rsvps for insert
to anon, authenticated
with check (
  char_length(trim(guest_name)) between 1 and 100
  and attendance in ('yes', 'no')
  and guest_count between 1 and 5
  and (message is null or char_length(message) <= 500)
);

-- Chỉ Admin được đọc RSVP.
create policy "Admin can read RSVP"
on public.rsvps for select
to authenticated
using (auth.uid() = 'YOUR_ADMIN_USER_UUID'::uuid);

-- Cấp đúng quyền cần thiết; RLS tiếp tục lọc các hàng theo policy.
grant select on public.site_settings to anon, authenticated;
grant update on public.site_settings to authenticated;
grant insert on public.rsvps to anon, authenticated;
grant select on public.rsvps to authenticated;
grant usage, select on sequence public.rsvps_id_seq to anon, authenticated;
