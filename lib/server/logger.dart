abstract class Logger {

	static Future<Null> e(e) async {
		print('[ERR] $e');
	}

	static Future<Null> i(e) async {
		print('[INFO] $e');
	}

}