package com.ljx.forum.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ljx.forum.common.Result;
import com.ljx.forum.common.annotation.RequireAdmin;
import com.ljx.forum.dto.PasswordUpdateRequest;
import com.ljx.forum.dto.UserUpdateRequest;
import com.ljx.forum.entity.User;
import com.ljx.forum.service.AuthService;
import com.ljx.forum.service.IUserService;
import com.ljx.forum.utils.SecurityUtils;
import com.ljx.forum.vo.UserVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * <p>
 * 用户表 前端控制器
 * </p>
 *
 * @author ljx
 * @since 2025-11-21
 */
@Tag(name = "用户管理")
@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserController {
    private final IUserService userService;

    @Operation(summary = "获取指定用户信息(个人主页)")
    @GetMapping("/{id}")
    public Result<UserVO> getUserProfile(@PathVariable Long id) {
        return Result.success(userService.getUserProfile(id));
    }

    @Operation(summary = "修改个人信息")
    @PutMapping("/update")
    public Result<String> updateInfo(@RequestBody @Valid UserUpdateRequest req) {
        userService.updateUserInfo(req);
        return Result.success("修改成功");
    }

    @Operation(summary = "分页查询用户列表(用于管理或搜索)")
    @GetMapping("/list")
    @RequireAdmin
    public Result<Page<UserVO>> list(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String keyword // 搜索关键词
    ) {
        Page<UserVO> page = userService.getUserList(new Page<>(pageNum, pageSize), keyword);
        return Result.success(page);
    }

    @Operation(summary = "修改密码")
    @PutMapping("/password")
    public Result<String> updatePassword(
            @RequestBody @Valid PasswordUpdateRequest req,
            HttpServletRequest request
    ) {
        // 执行修改密码逻辑
        userService.updatePassword(req);

        return Result.success("密码修改成功，请重新登录");
    }

}
