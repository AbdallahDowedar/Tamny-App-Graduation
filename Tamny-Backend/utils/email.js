import nodemailer from "nodemailer";

const transporter = nodemailer.createTransport({
  service: "Gmail",
  auth: {
    user: "ecommercep671@gmail.com",
    pass: "vxju wbex eoez aaya",
  },
});

export const sendEmail = async (to, content) => {
  await transporter.sendMail({
    from: "Your App <ecommercep671@gmail.com>",
    to,
    subject: "OTP Code",
    text: content,
  });
};
