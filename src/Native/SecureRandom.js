Elm.Native.SecureRandom = {}; // eslint-disable-line no-undef
Elm.Native.SecureRandom.make = function(localRuntime) {  // eslint-disable-line no-undef
  localRuntime.Native = localRuntime.Native || {};
  localRuntime.Native.SecureRandom = localRuntime.Native.SecureRandom || {};
  if (localRuntime.Native.SecureRandom.values) {
    return localRuntime.Native.SecureRandom.values;
  }

  var Task = Elm.Native.Task.make(localRuntime);  // eslint-disable-line no-undef

  if (typeof window === 'object' && typeof window.crypto === 'object'
    && typeof window.crypto.getRandomValues === 'function') {
    var crypto = window.crypto;

    return localRuntime.Native.SecureRandom.values = {
      getRandomInts: function (count) {
        return Task.asyncFunction(function (callback) {
          callback(Task.succeed(crypto.getRandomValues(new Uint32Array(count))));
        });
      },

      getRandomInt: function () {
        return Task.asyncFunction(function (callback) {
          callback(Task.succeed(crypto.getRandomValues(new Uint32Array(1))[0]));
        });
      }
    };
  } else {
    var fail = function () {
      return Task.asyncFunction(function (callback) {
        callback(Task.fail({ ctor: 'NoGetRandomValues' }));
      });
    };

    return localRuntime.Native.SecureRandom.values = {
      getRandomInts: fail,
      getRandomInt: fail
    };
  }
};
