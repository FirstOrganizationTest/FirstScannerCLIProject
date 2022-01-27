class ClassWithStaticMethod {
 static testCreateHash(){                
    const crypto = require("crypto");        
    const hash = crypto.createHash('SHA-3');
    return hash;    
}
}

console.log(ClassWithStaticMethod.staticProperty);
// output: "someValue"
console.log(ClassWithStaticMethod.staticMethod());
// output: "static method has been called."
