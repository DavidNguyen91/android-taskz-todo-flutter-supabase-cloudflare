/// Centralized UI strings supporting English and Vietnamese.
/// Ensures consistent naming, accessible labels, and easy localization.
class AppStrings {
  final bool isVietnamese;

  const AppStrings({this.isVietnamese = false});

  // App Identity
  String get appTitle => 'Tasks';
  String get myTasks => isVietnamese ? 'Công việc của tôi' : 'My Tasks';
  String get subtitle => isVietnamese
      ? 'Theo dõi những gì quan trọng hôm nay.'
      : 'Keep track of what matters today.';

  // Auth
  String get signInTitle => isVietnamese ? 'Đăng nhập vào tài khoản' : 'Sign in to your account';
  String get signUpTitle => isVietnamese ? 'Tạo tài khoản mới' : 'Create an account';
  String get signInSubtitle => isVietnamese
      ? 'Đăng nhập để đồng bộ các công việc an toàn.'
      : 'Sign in to access and sync your tasks securely.';
  String get signUpSubtitle => isVietnamese
      ? 'Đăng ký để bắt đầu sắp xếp và đồng bộ công việc.'
      : 'Sign up to start organizing and syncing your tasks securely.';
  String get continueWithGoogle => isVietnamese ? 'Tiếp tục với Google' : 'Continue with Google';
  String get orContinueWithEmail => isVietnamese ? 'hoặc tiếp tục với email' : 'or continue with email';
  String get emailLabel => 'Email';
  String get emailPlaceholder => 'you@example.com';
  String get passwordLabel => isVietnamese ? 'Mật khẩu' : 'Password';
  String get passwordPlaceholder => '••••••••';
  String get signInButton => isVietnamese ? 'Đăng nhập' : 'Sign In';
  String get signUpButton => isVietnamese ? 'Tạo tài khoản' : 'Create account';
  String get switchToSignUp => isVietnamese ? 'Chưa có tài khoản? Đăng ký' : "Don't have an account? Sign up";
  String get switchToSignIn => isVietnamese ? 'Đã có tài khoản? Đăng nhập' : 'Already have an account? Sign in';
  String get signOut => isVietnamese ? 'Đăng xuất' : 'Sign Out';
  String get signOutConfirmTitle => isVietnamese ? 'Đăng xuất tài khoản?' : 'Sign out of your account?';
  String get signOutConfirmMessage => isVietnamese
      ? 'Bạn sẽ cần đăng nhập lại để xem và đồng bộ công việc.'
      : 'You will need to sign in again to access and sync your tasks.';
  String get cancel => isVietnamese ? 'Hủy' : 'Cancel';
  String get confirm => isVietnamese ? 'Đồng ý' : 'Confirm';

  // Task Input & Actions
  String get taskInputPlaceholder => isVietnamese ? 'Thêm công việc mới...' : 'Add a new task...';
  String get addTaskTooltip => isVietnamese ? 'Thêm công việc' : 'Add task';
  String get editTaskTitle => isVietnamese ? 'Chỉnh sửa công việc' : 'Edit Task';
  String get saveTask => isVietnamese ? 'Lưu' : 'Save';
  String get deleteTask => isVietnamese ? 'Xóa' : 'Delete';
  String get clearCompleted => isVietnamese ? 'Xóa việc đã xong' : 'Clear completed';
  String get clearCompletedConfirmTitle => isVietnamese ? 'Xóa tất cả việc đã hoàn thành?' : 'Clear all completed tasks?';
  String get clearCompletedConfirmMessage => isVietnamese
      ? 'Hành động này sẽ xóa vĩnh viễn tất cả các việc đã xong và không thể hoàn tác.'
      : 'This action will permanently delete all completed tasks and cannot be undone.';

  // Filters
  String get filterAll => isVietnamese ? 'Tất cả' : 'All';
  String get filterActive => isVietnamese ? 'Chưa xong' : 'Active';
  String get filterCompleted => isVietnamese ? 'Đã xong' : 'Completed';

  // Status & Badges
  String remainingTasks(int count) => isVietnamese ? '$count việc còn lại' : '$count remaining';
  String get allTasksCompleted => isVietnamese ? 'Đã xong tất cả' : 'All tasks completed';

  // Empty States (Aligned 100% with Next.js)
  String get emptyAllTitle => isVietnamese ? 'Chưa có công việc nào' : 'No Tasks Yet';
  String get emptyAllDescription => isVietnamese
      ? 'Nhập công việc vào ô bên trên để sắp xếp mục tiêu và kế hoạch hàng ngày.'
      : 'Type a task in the field above to organize your goals and daily to-dos.';

  String get emptyActiveTitle => isVietnamese ? 'Đã hoàn thành tất cả' : 'All Caught Up';
  String get emptyActiveDescription => isVietnamese
      ? 'Bạn đã hoàn thành tất cả công việc đang làm. Hãy nghỉ ngơi hoặc thêm việc mới.'
      : 'You have finished all active tasks. Take a break or add a new one.';

  String get emptyCompletedTitle => isVietnamese ? 'Chưa có việc hoàn thành' : 'No Completed Tasks';
  String get emptyCompletedDescription => isVietnamese
      ? 'Các công việc bạn đánh dấu xong sẽ xuất hiện ở đây để dễ theo dõi.'
      : 'Tasks you check off will appear here for easy reference.';

  // Errors & Feedback
  String get titleCannotBeEmpty => isVietnamese ? 'Tiêu đề không được để trống' : 'Task title cannot be empty';
  String get titleTooLong => isVietnamese ? 'Tiêu đề không được vượt quá 300 ký tự' : 'Task title cannot exceed 300 characters';
  String get errorGeneric => isVietnamese ? 'Đã xảy ra lỗi. Vui lòng thử lại.' : 'An error occurred. Please try again.';
  String get retry => isVietnamese ? 'Thử lại' : 'Retry';
  String get offlineMessage => isVietnamese ? 'Mất kết nối internet. Đang ở chế độ xem.' : 'No internet connection. Viewing offline.';
}
