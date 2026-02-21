package com.ljx.forum.dto;

import com.ljx.forum.entity.User;
import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * @Author: ljx
 * @Date: 2025/11/22 17:23
 */
@Data
@AllArgsConstructor
public class LoginResult {
    String token;
    User user;
}
