import type { Request, Response, NextFunction } from "express";
import jwt, { type JwtPayload } from "jsonwebtoken";

declare global {
    namespace Express {
        interface Request {
            users?: string;
        }
    }
}
export const authMiddleware = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const token = req.headers.authorization?.split(" ")[1];
        if (!token) {
            return res
                .status(401)
                .json({ success: false, message: "Not Authorized!" });
        }
        const verifyToken = jwt.verify(
            token,
            process.env.JWT_SECRET || "default_secret"
        ) as JwtPayload;

        if (verifyToken.userId) {
            req.users = verifyToken.userId;
        } else {
            return res
                .status(401)
                .json({ success: false, message: "Not Authorized!" });
        }

        next();
    } catch (error) {
        console.log(error);
        return res
            .status(401)
            .json({ success: false, message: "Not Authorized!" });
    }
};
