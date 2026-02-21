package com.ljx.forum.service;

import com.ljx.forum.dto.CommentCreateRequest;
import com.ljx.forum.entity.Comment;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ljx.forum.vo.CommentVO;

import java.util.List;

/**
 * <p>
 * 评论表 服务类
 * </p>
 *
 * @author ljx
 * @since 2025-11-21
 */
public interface ICommentService extends IService<Comment> {
    void createComment(CommentCreateRequest req);
    void deleteComment(Long commentId);
    List<CommentVO> getCommentsByPostId(Long postId);
    List<CommentVO> getSubComments(Long rootId);
}
