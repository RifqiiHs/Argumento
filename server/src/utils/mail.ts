import nodemailer from "nodemailer";

const transporter = nodemailer.createTransport({
    service: "gmail",
    host: "smtp.gmail.com",
    port: 587,
    secure: false,
    auth: {
        user: process.env.GMAIL_USER,
        pass: process.env.GMAIL_APP_PASS,
    },
});

export const sendVerificationEmail = async (toEmail: string, token: string) => {
    const verifyLink = `${process.env.CORS_ORIGIN}/verify/${token}`;

    try {
        const info = await transporter.sendMail({
            from: "Argumento",
            to: toEmail,
            subject: "Verify Email",
            html: `            
            <!DOCTYPE html>
            <html>
            <body style="margin: 0; padding: 0; background-color: #000000; font-family: 'Courier New', Courier, monospace;">
                <div style="max-width: 600px; margin: 0 auto; padding: 40px 20px; border: 1px solid #333;">
                    <h1 style="color: #fff;">Welcome to Argumento!</h1>
                    <p style="color: #cccccc; margin-bottom: 30px;">
                        Before that, we need to verify your indentity (Email: <span style="color: #fff;">${toEmail}</span>).
                        <br>Click the button below to verify.
                    </p>

                    <a href="${verifyLink}" style="
                        display: inline-block;
                        background-color: #22c55e;
                        color: #000000;
                        text-decoration: none;
                        padding: 15px 30px;
                        font-weight: bold;
                        font-size: 16px;
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        border: 2px solid #22c55e;
                    ">
                        Verify
                    </a>

                    <div style="margin-top: 30px; border-top: 1px solid #333; padding-top: 20px;">
                        <p style="color: #666666; font-size: 12px;">
                            Or copy and paste this link:
                        </p>
                        <a href="${verifyLink}" style="color: #4ade80; font-size: 12px; word-break: break-all;">
                            ${verifyLink}
                        </a>
                    </div>

                </div>
            </body>
            </html>`,
        });

        console.log("Link Sent: %s", info.messageId);
        return { success: true };
    } catch (error) {
        console.error("Link Failed:", error);
        return { success: false, error };
    }
};

export const sendResetPasswordEmail = async (toEmail: string, code: string) => {
    const resetLink = `${process.env.CORS_ORIGIN}/reset-password/${code}`;

    try {
        const info = await transporter.sendMail({
            from: '"Argumento" <yourpersonalemail@gmail.com>',
            to: toEmail,
            subject: "Security Alert: Password Reset Request",
            html: `
            <!DOCTYPE html>
            <html>
            <body style="margin: 0; padding: 0; background-color: #000000; font-family: 'Courier New', Courier, monospace;">
                <div style="max-width: 600px; margin: 0 auto; padding: 40px 20px; border: 1px solid #333;">

                    <div style="color: #e4e4e7; margin: 30px 0;">
                        <p style="margin-bottom: 20px;">
                            A password reset was initiated for user: <span style="color: #fff; font-weight: bold;">${toEmail}</span>.
                        </p>
                        <p style="margin-bottom: 30px; font-size: 14px; color: #a1a1aa;">
                            If you authorized this action, click the button below to begin password reset.
                        </p>

                        <a href="${resetLink}" style="
                            display: inline-block;
                            background-color: #22c55e;
                            color: #000000;
                            text-decoration: none;
                            padding: 15px 30px;
                            font-weight: bold;
                            font-size: 16px;
                            text-transform: uppercase;
                            letter-spacing: 1px;
                            border: 2px solid #22c55e;
                        ">
                            RESET PASSWORD
                        </a>

                        <div style="margin-top: 30px; background: #111; padding: 15px; border-radius: 4px;">
                            <p style="color: #666666; font-size: 10px; margin-top: 0; text-transform: uppercase;">
                                Or copy and paste this link
                            </p>
                            <a href="${resetLink}" style="color: #4ade80; font-size: 12px; word-break: break-all; text-decoration: none;">
                                ${resetLink}
                            </a>
                        </div>
                    </div>

                    <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #333; font-size: 11px; color: #52525b;">
                        <p style="margin: 0;">
                            <strong>WARNING:</strong> If you did not request this, ignore this email.
                        </p>
                    </div>

                </div>
            </body>
            </html>
            `,
        });

        console.log("Reset Email Sent: %s", info.messageId);
        return { success: true };
    } catch (error) {
        console.error("Reset Email Failed:", error);
        return { success: false, error };
    }
};
