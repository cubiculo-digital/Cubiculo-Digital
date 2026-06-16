import { describe, it, expect } from 'vitest';
import jwt from 'jsonwebtoken';

const TEST_SECRET = 'test-secret-key-for-unit-tests';
const TEST_USER_ID = '550e8400-e29b-41d4-a716-446655440000';

describe('SEC-01: JWT expiry', () => {
  it('should include exp claim when expiresIn is provided', () => {
    const token = jwt.sign({ userId: TEST_USER_ID }, TEST_SECRET, {
      expiresIn: '1d',
    });

    const decoded = jwt.decode(token) as jwt.JwtPayload;

    expect(decoded).toBeDefined();
    expect(decoded.exp).toBeDefined();
    expect(decoded.iat).toBeDefined();
    expect(decoded.userId).toBe(TEST_USER_ID);
  });

  it('should set expiry to exactly 1 day (86400 seconds)', () => {
    const token = jwt.sign({ userId: TEST_USER_ID }, TEST_SECRET, {
      expiresIn: '1d',
    });

    const decoded = jwt.decode(token) as jwt.JwtPayload;
    const diffSeconds = (decoded.exp as number) - (decoded.iat as number);

    expect(diffSeconds).toBe(86400);
  });

  it('should verify a token that has not expired', () => {
    const token = jwt.sign({ userId: TEST_USER_ID }, TEST_SECRET, {
      expiresIn: '1d',
    });

    const verified = jwt.verify(token, TEST_SECRET) as jwt.JwtPayload;

    expect(verified.userId).toBe(TEST_USER_ID);
  });

  it('should reject a token that has expired', () => {
    // Create a token that expired 1 hour ago
    const token = jwt.sign({ userId: TEST_USER_ID }, TEST_SECRET, {
      expiresIn: '-1h',
    });

    expect(() => jwt.verify(token, TEST_SECRET)).toThrow('jwt expired');
  });

  it('should NOT include exp claim when expiresIn is omitted', () => {
    // This test proves WHY the fix was needed: tokens without
    // expiresIn never expire (P0-critical vulnerability)
    const token = jwt.sign({ userId: TEST_USER_ID }, TEST_SECRET);

    const decoded = jwt.decode(token) as jwt.JwtPayload;

    expect(decoded.exp).toBeUndefined();
  });
});
