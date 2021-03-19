import 'dart:io';

import 'package:happy_hour_server/persistance/model/auth.dart';
import 'package:happy_hour_server/server/request_filter.dart';
import 'package:happy_hour_server/server/response.dart';

class FilterAccountTypeAdmin extends RequestFilter {

	@override
	bool doFilter(HttpRequest request) => (request.session['Auth'] as Auth).type == 1;

	@override
	Future onError(HttpRequest request) => Response.forbidden(request);
	
}