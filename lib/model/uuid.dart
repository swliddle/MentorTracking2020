// NEEDSWORK: I know this isn't really a UUID. We should fix this sometime.

int _nextIdValue = 10;

int nextId() {
  _nextIdValue += 1;

  return _nextIdValue;
}

setId(int id) {
  _nextIdValue = id;
}
