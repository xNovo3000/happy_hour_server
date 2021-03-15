import 'dart:io';

abstract class RequestFilter {

	bool doFilter(HttpRequest request);

	Future onError(HttpRequest request);

}