import 'package:objectbox/objectbox.dart';
import 'package:travel_planner/data/model/message.dart';

@Entity()
class Conversation {
  @Id()
  int id = 0;
  String? title;

  @Backlink('conversation')
  final messages = ToMany<Message>();

  Conversation({this.id = 0, this.title});
}
