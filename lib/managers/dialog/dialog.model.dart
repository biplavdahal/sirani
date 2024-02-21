enum DialogType { progressDialog, selection, incomingCall }

class DialogRequest<T> {
  final DialogType type;
  final String title;
  final T? payload;
  final bool dismissable;

  DialogRequest({
    required this.type,
    required this.title,
    this.payload,
    this.dismissable = false,
  });
}

class DialogResponse<T> {
  final T? result;

  DialogResponse({this.result});
}
