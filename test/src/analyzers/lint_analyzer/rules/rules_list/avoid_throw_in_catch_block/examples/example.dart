void main() {
  try {
    repository();
  } on Object catch (error, stackTrace) {
    logError(error, stackTrace);
  }
}

/// Where did the original error occur based on the log?
void logError(Object error, StackTrace stackTrace) =>
    print('$error\n$stackTrace');

void repository() {
  try {
    networkDataProvider();
  } on Object {
    throw RepositoryException(); // LINT
  }
}

void networkDataProvider() {
  try {
    networkClient();
  } on Object {
    throw DataProviderException(); // LINT
  }
}

void networkClient() {
  throw 'Some serious problem';
}

class RepositoryException {}

class DataProviderException {}
