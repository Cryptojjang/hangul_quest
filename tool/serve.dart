// Minimal static server for build/web — dev verification only.
// ignore_for_file: avoid_print
import 'dart:io';

Future<void> main(List<String> args) async {
  final root = args.isNotEmpty ? args[0] : 'build/web';
  // Port precedence: CLI arg > PORT env (dev-harness assigned) > default.
  final port = args.length > 1
      ? int.parse(args[1])
      : int.tryParse(Platform.environment['PORT'] ?? '') ?? 8321;
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('serving $root on http://localhost:$port');
  const types = {
    '.html': 'text/html', '.js': 'application/javascript',
    '.css': 'text/css', '.json': 'application/json',
    '.png': 'image/png', '.otf': 'font/otf', '.ttf': 'font/ttf',
    '.wasm': 'application/wasm', '.svg': 'image/svg+xml',
    '.wav': 'audio/wav', '.mp3': 'audio/mpeg', '.m4a': 'audio/mp4',
    '.ogg': 'audio/ogg',
  };
  await for (final req in server) {
    var path = req.uri.path == '/' ? '/index.html' : req.uri.path;
    final file = File('$root$path');
    if (await file.exists()) {
      final dot = path.lastIndexOf('.');
      final ext = dot < 0 ? '' : path.substring(dot);
      req.response.headers
        ..set('Content-Type', types[ext] ?? 'application/octet-stream')
        // Dev server: never let the service worker pin a stale build.
        ..set('Cache-Control', 'no-cache');
      await req.response.addStream(file.openRead());
    } else {
      req.response.statusCode = 404;
    }
    await req.response.close();
  }
}
