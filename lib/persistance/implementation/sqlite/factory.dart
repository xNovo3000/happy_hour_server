import 'dart:io';

import 'package:happy_hour_server/server/logger.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../connection/dao/auction.dart';
import '../../connection/dao/auth.dart';
import '../../connection/dao/bid.dart';
import '../../connection/dao/user.dart';
import '../../connection/factory.dart';
import 'dao/auction.dart';
import 'dao/auth.dart';
import 'dao/bid.dart';
import 'dao/user.dart';

class SqliteDaoFactory extends DaoFactory {

	SqliteDaoFactory() : _database = sqlite3.open('data/persistance/db.sl3') {
		List<String> startActions = File('data/script/v1.sql').readAsStringSync().split(';');
		try {
			startActions.forEach((action) => _database.execute(action));
		} on SqliteException catch (e) {
			Logger.e(e);
		}
		_userDao = SqliteUserDao(_database);
		_authDao = SqliteAuthDao(_database);
		_auctionDao = SqliteAuctionDao(_database);
		_bidDao = SqliteBidDao(_database);
	}

	final Database _database;

	late UserDao _userDao;
	late AuthDao _authDao;
	late AuctionDao _auctionDao;
	late BidDao _bidDao;

	@override UserDao get userDao => _userDao;
	@override AuthDao get authDao => _authDao;
	@override AuctionDao get auctionDao => _auctionDao;
	@override BidDao get bidDao => _bidDao;

	@override int get lastRowInsertedId => _database.lastInsertRowId;

}