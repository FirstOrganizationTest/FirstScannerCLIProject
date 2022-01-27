function sha256(input) {
		var hash = new crypto.createHash('sha256');

		hash.write(input);
		hash.end();

		var buffer = new Buffer(hash.read());

		return buffer;
}

function getMessageSignature(path, request, nonce) {
        var message = querystring.stringify(request);        
        var hash = new crypto.createHash('sha256');
        var hash_digest = hash.update(nonce + message).digest('binary');
        return hash_digest;
  }


static testCreateHash(){                
    const crypto = require("crypto");        
    let hash = crypto.createHash('sha256').update("test").digest('hex');
    return hash;    
}