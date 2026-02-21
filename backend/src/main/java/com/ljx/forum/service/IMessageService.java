package com.ljx.forum.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ljx.forum.entity.Message;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ljx.forum.vo.ConversationVO;
import com.ljx.forum.vo.MessageVO;
import com.ljx.forum.vo.UnreadCountVO;

import java.util.List;

/**
 * <p>
 * 消息通知表 服务类
 * </p>
 *
 * @author ljx
 * @since 2025-11-21
 */
public interface IMessageService extends IService<Message> {
    // 发送私信
    void sendPrivateMessage(Long toUserId, String content);
    // 创建通知 (通用内部方法，供 CommentService 调用)
    void createSystemNotification(Long fromId, Long toId, String type, String content);
    // 获取我的消息列表 (支持分页)
    Page<MessageVO> getMyMessages(Page<Message> page, String type);
    // 标记已读
    void markAsRead(Long id);
    // 获取未读数量 (用于前端小红点)
    Long getUnreadCount();
    // 获取会话列表 (左侧栏)
    List<ConversationVO> getConversationList();
    // 获取与某人的详细聊天记录 (右侧栏)
    List<MessageVO> getChatHistory(Long partnerId);
    // 批量标记已读
    void batchMarkAsRead(List<Long> ids);
    // 全部已读
    void markAllAsRead();
    // 获取分类未读数
    UnreadCountVO getUnreadCountByType();
}
