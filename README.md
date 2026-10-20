# Thiệp mời RSVP + Admin

Bản khởi đầu HTML/CSS/JavaScript, Supabase và hosting tĩnh. Phản hồi được ghi vào database; Admin cập nhật dữ liệu khi tải lại trang hoặc bấm nút tải lại.

## 1. Tạo database

1. Tạo project tại https://supabase.com/
2. Trong Authentication > Users, tạo thủ công user Admin với mật khẩu mạnh; sao chép UUID của user đó.
3. Mở `schema.sql`, thay mọi `YOUR_ADMIN_USER_UUID` bằng UUID thật trước khi chạy (nếu không, PostgreSQL sẽ báo UUID không hợp lệ).
4. Vào SQL Editor và chạy toàn bộ `schema.sql`.
5. Trong Authentication settings, tắt public sign-ups để người ngoài không tự tạo tài khoản. Chỉ tài khoản Admin do bạn kiểm soát mới được tạo.

## 2. Cấu hình website

1. Mở `config.js`.
2. Điền Project URL và Publishable key từ Supabase Dashboard > Connect / API Keys.
3. Chỉ dùng publishable key ở frontend. Không bao giờ đưa `sb_secret_*` hoặc `service_role` key vào file công khai.

## 3. Chạy thử

Có thể mở `index.html` để kiểm tra giao diện, nhưng trình duyệt/thiết lập cục bộ có thể chặn một số request. Nên chạy bằng local static server hoặc triển khai lên hosting.

## 4. Đưa lên Internet miễn phí

1. Tạo repository GitHub riêng và tải các file `index.html`, `admin.html`, `config.js` lên.
2. Import repository vào Vercel và triển khai dạng static site.
3. Link thiệp là domain gốc `/`; trang Admin là `/admin.html`.
4. Mở thử link trên một thiết bị khác; gửi phản hồi rồi đăng nhập Admin và bấm tải lại danh sách.

## 5. Bảo mật và giới hạn của bản mẫu

- RLS là lớp bảo vệ quan trọng; không được bỏ qua hoặc tắt RLS.
- Admin được giới hạn bằng UUID trong policy. Phải thay placeholder bằng UUID thật.
- Không bật đăng ký công khai. Không dựa vào việc ẩn giao diện Admin để bảo vệ dữ liệu.
- RSVP công khai có thể bị spam. Với sự kiện lớn, nên bổ sung CAPTCHA/giới hạn tần suất qua backend hoặc Edge Function.
- Bản mẫu không có chống gửi trùng, chỉnh sửa RSVP của khách, tải CSV hay upload ảnh.
- Chỉ lưu dữ liệu cần thiết; tránh thu thập thông tin nhạy cảm.
