import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.GMAIL_USER,
    pass: process.env.GMAIL_APP_PASS,
  },
});

export const sendVerificationEmail = async (email: string, token: string): Promise<void> => {
  const verifyUrl = `${process.env.APP_URL || 'http://localhost:3000'}/verify/${token}`;

  await transporter.sendMail({
    from: `"Argumento" <${process.env.GMAIL_USER}>`,
    to: email,
    subject: 'Verify Your Argumento Account',
    html: `
      <div style="font-family: monospace; background: #09090b; color: #d4d4d8; padding: 40px; max-width: 600px; margin: 0 auto;">
        <h1 style="color: #22c55e; text-transform: uppercase; letter-spacing: 2px;">ARGUMENTO</h1>
        <h2 style="color: white;">Verify Your Account</h2>
        <p>Your verification code:</p>
        <div style="background: #18181b; border: 1px solid #22c55e; padding: 20px; text-align: center; margin: 20px 0;">
          <span style="font-size: 32px; font-weight: bold; color: #22c55e; letter-spacing: 8px;">${token}</span>
        </div>
        <p style="color: #71717a;">This code expires in 1 hour. If you didn't create an account, ignore this email.</p>
      </div>
    `,
  });
};

export const sendResetPasswordEmail = async (email: string, token: string): Promise<void> => {
  await transporter.sendMail({
    from: `"Argumento" <${process.env.GMAIL_USER}>`,
    to: email,
    subject: 'Reset Your Argumento Password',
    html: `
      <div style="font-family: monospace; background: #09090b; color: #d4d4d8; padding: 40px; max-width: 600px; margin: 0 auto;">
        <h1 style="color: #22c55e; text-transform: uppercase; letter-spacing: 2px;">ARGUMENTO</h1>
        <h2 style="color: white;">Password Reset</h2>
        <p>Your reset token:</p>
        <div style="background: #18181b; border: 1px solid #ef4444; padding: 20px; text-align: center; margin: 20px 0;">
          <span style="font-size: 28px; font-weight: bold; color: #ef4444; letter-spacing: 6px;">${token}</span>
        </div>
        <p style="color: #71717a;">This code expires in 1 hour.</p>
      </div>
    `,
  });
};
