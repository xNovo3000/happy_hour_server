import '../implementation/sqlite/factory.dart';
import 'dao/auction.dart';
import 'dao/auth.dart';
import 'dao/bid.dart';
import 'dao/user.dart';

abstract class DaoFactory {

	UserDao get userDao;
	AuthDao get authDao;
	AuctionDao get auctionDao;
	BidDao get bidDao;

	int get lastRowInsertedId;

	static DaoFactory? _instance;
	static DaoFactory get instance {
		if (_instance == null) _instance = SqliteDaoFactory();
		return _instance!;
	}

}