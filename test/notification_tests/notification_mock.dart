import 'package:mockito/mockito.dart';
import 'package:reazzon/src/notifications/notification_bloc.dart';
import 'package:reazzon/src/notifications/notification_repository.dart';

class NotificationRepositoryMock extends Mock implements NotificationRepository {}

class NotificationBlocMock extends Mock implements NotificationBloc {
  NotificationRepositoryMock notificationRepository;

  NotificationBlocMock({this.notificationRepository});
}