package com.ljx.forum.service;

import com.ljx.forum.dto.LoginRequest;
import com.ljx.forum.dto.LoginResult;
import com.ljx.forum.dto.RegisterRequest;

/**
 * @Author: ljx
 * @Date: 2025/11/21 14:24
 */
public interface AuthService {
    void register(RegisterRequest req);
    LoginResult login(LoginRequest req);
}
