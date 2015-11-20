Elm.Native.SecureRandom = {};
Elm.Native.SecureRandom.make = function(localRuntime) {

    localRuntime.Native = localRuntime.Native || {};
    localRuntime.Native.SecureRandom = localRuntime.Native.SecureRandom || {};
    if (localRuntime.Native.SecureRandom.values) {
        return localRuntime.Native.SecureRandom.values;
    }

    var Task = Elm.Native.Task.make(localRuntime);

    if (typeof window === 'object' && typeof window.crypto === 'object'
        && typeof window.crypto.getRandomValues === 'function') {
        var crypto = window.crypto;

        return localRuntime.Native.SecureRandom.values = {
            getRandomInts: function(count) {
                return Task.succeed(crypto.getRandomValues(new Uint32Array(count)));
            },

            getRandomInt: function() {
                return Task.succeed(crypto.getRandomValues(new Uint32Array(1))[0]);
            }
        };
    } else {
        var fail = function () {
            return Task.fail({ ctor: 'NoGetRandomValues' });
        };

        return localRuntime.Native.SecureRandom.values = {
            getRandomInts: fail,
            getRandomInt: fail
        };
    }
};
