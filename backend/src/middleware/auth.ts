import type { Request, Response, NextFunction } from 'express';
import jwt, { type JwtPayload } from 'jsonwebtoken';

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
): Promise<void> => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) {
      res.status(401).json({ success: false, message: 'Not Authorized!' });
      return;
    }
    const verifyToken = jwt.verify(
      token,
      process.env.JWT_SECRET || 'default_secret'
    ) as JwtPayload;

    if (verifyToken.userId) {
      req.users = verifyToken.userId;
    } else {
      res.status(401).json({ success: false, message: 'Not Authorized!' });
      return;
    }
    next();
  } catch (error) {
    console.log(error);
    res.status(401).json({ success: false, message: 'Not Authorized!' });
  }
};
