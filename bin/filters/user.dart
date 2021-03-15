import 'dart:io';

import 'package:happy_hour_server/persistance/model/auth.dart';
import 'package:happy_hour_server/server/request_filter.dart';
import 'package:happy_hour_server/server/response.dart';

class FilterUser extends RequestFilter {

	@override
	bool doFilter(HttpRequest request) {
		Auth? auth = request.session['Auth'];
		if (auth == null) {
			return false;
		}
		if (auth.user != null) {
			return true;
		} else {
			return false;
		}
	}

	@override
	Future onError(HttpRequest request) => Response.forbidden(request);

}