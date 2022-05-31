import 'package:flutter/material.dart';
import 'package:pokhara_app/utils/map/map_download/download_view.dart';
import 'package:pokhara_app/utils/utilities.dart';

class MapDownloader {
  static Function _onDownload;
  static BuildContext _context;
  static bool _isDownloading = false;

  MapDownloader(Function onDownloaded, BuildContext cntx, path) {
    _onDownload = onDownloaded;
    _context = cntx;
    if (!_isDownloading) {
      _downloadMap(path);
    }
  }

  Future<void> _downloadMap(path) async {
    _isDownloading = true;
    var resp = await showDialog(
      barrierDismissible: false,
      context: _context,
      builder: (BuildContext context) {
        return MapDownloadView(
          path: path,
        );
      },
    );
    _isDownloading = false;
    if (resp != null) {
      if (resp) {
        Utilities.showInToast('Map Downloaded', toastType: ToastType.SUCCESS);
        _onDownload();
      } else {}
    } else {
      Utilities.showInToast('Failed to download map.',
          toastType: ToastType.ERROR);
      _onDownload();
    }
  }
}
