import  jwt from 'jsonwebtoken'

export const GenerateToken =(Payload)=>{
    const token = jwt.sign(Payload , process.env.JWTSECRETKEY,{expiresIn : "1d"})
    return token
}
