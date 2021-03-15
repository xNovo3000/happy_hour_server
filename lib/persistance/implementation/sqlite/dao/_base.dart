import 'package:sqlite3/sqlite3.dart';

import '../../../connection/dao/_base.dart';
import '../../../model/_entity.dart';

abstract class SqliteBaseDao<T extends Entity> implements BaseDao<T> {

	const SqliteBaseDao(this.database);

	final Database database;

}