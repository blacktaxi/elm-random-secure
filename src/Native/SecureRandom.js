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

    function runAsTask(action) {
      return Task.asyncFunction(function (callback) {
        var result, errorName = null, errorMessage = null;

        try { result = action(); }
        catch (err) {
          if (typeof err === 'object') {
            errorName = err.name || "";
            errorMessage = err.message || err.toString();
          } else {
            errorName = typeof err;
            errorMessage = err.toString();
          }
        }

        if (errorName !== null) {
          callback(Task.fail({ ctor: 'Exception', _0: errorName, _1: errorMessage }));
        } else {
          callback(Task.succeed(result));
        }
      });
    }

    return localRuntime.Native.SecureRandom.values = {
      getRandomInts: function (count) {
        return runAsTask(function () {
          return crypto.getRandomValues(new Uint32Array(count));
        });
      },

      getRandomInt: function () {
        return runAsTask(function () {
          return crypto.getRandomValues(new Uint32Array(1))[0];
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
