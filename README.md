# Todo Mobile App – Flutter CI/CD Demo

Ứng dụng quản lý công việc cá nhân tối giản để trình diễn một thay đổi phần
mềm đi xuyên suốt pipeline CI/CD: chỉnh code, push lên `main`, tự động analyze,
test, build và xuất APK artifact.

## Tính năng

- Xem danh sách công việc và tiến độ hoàn thành.
- Thêm công việc mới (có kiểm tra dữ liệu rỗng).
- Đánh dấu/bỏ đánh dấu công việc đã hoàn thành.
- Xóa công việc.
- Lưu dữ liệu local bằng `SharedPreferencesAsync`, không cần backend.

## Cấu trúc chính

```text
lib/
├── controllers/todo_controller.dart       # Logic thêm/sửa/xóa
├── data/                                   # Abstraction + local storage
├── models/todo_item.dart                   # Todo model
├── screens/todo_home_page.dart             # Giao diện chính
├── main.dart
└── todo_app.dart
test/
├── todo_controller_test.dart               # Unit tests
└── todo_app_test.dart                      # Widget tests
.github/workflows/flutter-ci.yml             # CI/CD pipeline
```

## Chạy local

Yêu cầu Flutter stable và Android SDK. Nếu mới clone repository, tạo Android
host scaffold một lần (pipeline cũng tự thực hiện bước này):

```bash
flutter create --platforms=android --org com.example --project-name todo_mobile_app .
flutter pub get
flutter run
```

Kiểm tra tương tự CI:

```bash
flutter analyze --fatal-infos
flutter test
flutter build apk --release
```

APK local nằm tại:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Pipeline GitHub Actions

Workflow chạy khi push/pull request vào `main`, hoặc chạy thủ công bằng
**Run workflow**:

```text
Push main
   ↓
Checkout + Flutter stable + Java 17
   ↓
flutter pub get
   ↓
flutter analyze --fatal-infos
   ↓
flutter test --coverage
   ↓
flutter build apk --release
   ↓
Artifact: todo-mobile-app-release
```

Sau khi job xanh, vào trang **Actions → workflow run → Artifacts**, tải
`todo-mobile-app-release`, giải nén và cài APK:

```bash
adb install -r app-release.apk
```

## Kịch bản trình bày đề xuất (5–7 phút)

1. Mở phiên bản ban đầu và thêm một task, ví dụ `Chuẩn bị slide`.
2. Trình bày thay đổi “Đánh dấu task hoàn thành” trong
   `TodoController.toggleTodo` và checkbox trên UI.
3. Cho xem test `user can mark a todo as completed` bảo vệ hành vi mới.
4. Commit và push vào `main`:

   ```bash
   git add .
   git commit -m "feat: add task completion"
   git push origin main
   ```

5. Mở GitHub Actions, lần lượt cho thấy **Analyze PASS → Test PASS → Build
   PASS**.
6. Tải artifact, cài APK mới, tick task và cho thấy chữ bị gạch ngang cùng
   tiến độ `1/1 công việc hoàn thành`.

Điểm cần nhấn mạnh khi thuyết trình: artifact được tạo từ đúng commit đã vượt
qua analyze và automated tests, nên bản APK dùng để demo có thể truy vết và
lặp lại quy trình build.
