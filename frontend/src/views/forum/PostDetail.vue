<template>
    <div class="post-detail-container" v-loading="loading">
      <el-row :gutter="20">
        <el-col :span="17" :xs="24">
          <el-card class="post-card" shadow="never" v-if="post">
            <div class="post-header">
              <h1 class="post-title">{{ post.title }}</h1>
              <div class="post-meta">
                <el-tag size="small">{{ post.boardName }}</el-tag>
                <span class="meta-text">作者: {{ post.authorName }}</span>
                <span class="meta-text">发布于: {{ formatTime(post.createTime) }}</span>
                <span class="meta-text">阅读: {{ post.viewCount }}</span>
              </div>
            </div>
            
            <el-divider />
            
            <v-md-preview :text="post.content"></v-md-preview>
          </el-card>
  
          <el-card class="comment-card" shadow="never">
            <div class="comment-header">
              <h3>评论 ({{ post?.replyCount || 0 }})</h3>
            </div>
  
            <div class="comment-input-area">
              <el-input
                v-model="mainCommentContent"
                type="textarea"
                :rows="3"
                placeholder="写下你的评论..."
                resize="none"
              />
              <div class="input-actions">
                <el-button type="primary" @click="submitMainComment" :loading="submitting">发表评论</el-button>
              </div>
            </div>
  
            <div class="comment-list">
              <el-empty v-if="comments.length === 0" description="暂无评论，快来抢沙发" />
              
              <div v-for="comment in comments" :key="comment.id" class="comment-item">
                <div class="avatar-col">
                  <el-avatar :src="comment.authorAvatar || defaultAvatar" class="clickable-avatar" @click.stop="goToUser(comment.userId)" />
                </div>
                
                <div class="content-col">
                  <div class="user-info">
                    <span class="clickable-name" @click="goToUser(comment.userId)">{{ comment.authorName }}</span>
                    <span class="time">{{ formatTime(comment.createTime) }}</span>
                  </div>
                  
                  <div class="comment-text">{{ comment.content }}</div>
                  
                  <div class="action-bar">
                    <el-button link type="primary" size="small" @click="openReplyBox(comment)">回复</el-button>
                    <el-button 
                      v-if="userStore.userInfo?.username === comment.userId" 
                      link type="danger" size="small" 
                      @click="handleDelete(comment.id)"
                    >删除</el-button>
                  </div>
  
                  <div class="sub-comment-wrapper" v-if="comment.childCount > 0 || (comment.subComments && comment.subComments.length > 0)">
                    
                    <div v-if="comment.showReplies" class="sub-list">
                        <div v-for="sub in comment.subComments" :key="sub.id" class="sub-item">
                            <span class="sub-user">{{ sub.authorName }}</span> : 
                            <span class="sub-content">{{ sub.content }}</span>
                            
                            <div class="sub-actions">
                                <span class="sub-time">{{ formatTime(sub.createTime) }}</span>
                                <el-button link size="small" @click="openReplyBox(comment, sub)">回复</el-button>
                                <el-button 
                                v-if="userStore.userInfo?.username === sub.userId" 
                                link type="danger" size="small" 
                                @click="handleDelete(sub.id, comment)"
                                >删除</el-button>
                            </div>
                            </div>
                    </div>
  
                    <div class="expand-btn" v-if="comment.childCount > 0">
                      <el-button 
                        v-if="!comment.showReplies" 
                        link type="info" 
                        @click="fetchSubComments(comment)"
                        :loading="comment.loadingReplies"
                      >
                        查看 {{ comment.childCount }} 条回复 <el-icon><ArrowDown /></el-icon>
                      </el-button>
                      <el-button 
                        v-else 
                        link type="info" 
                        @click="comment.showReplies = false"
                      >
                        收起回复 <el-icon><ArrowUp /></el-icon>
                      </el-button>
                    </div>
                  </div>
  
                  <div v-if="activeReplyId === comment.id" class="inline-reply-box">
                    <el-input 
                      v-model="replyContent" 
                      :placeholder="replyPlaceholder" 
                      size="small"
                      @keyup.enter="submitReply(comment)"
                    >
                      <template #append>
                        <el-button @click="submitReply(comment)" :loading="replySubmitting">发送</el-button>
                      </template>
                    </el-input>
                  </div>
  
                </div>
              </div>
            </div>
          </el-card>
        </el-col>
  
        <el-col :span="7" class="hidden-xs-only">
          <el-card shadow="hover" v-if="post">
            <template #header>作者</template>
            <div class="author-card">
              <el-avatar :size="60" :src="post.authorAvatar || defaultAvatar" class="clickable-avatar" @click="goToUser(post.userId)" />
              <h3 style="margin-top: 10px" class="clickable-name" @click="goToUser(post.userId)">{{ post.authorName }}</h3>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, onMounted } from 'vue'
  import { useRoute, useRouter } from 'vue-router'
  import { useUserStore } from '@/store/userStore'
  import { getPostDetail, type PostVO } from '@/api/post'
  import { 
    getCommentList, 
    getSubCommentList, 
    createComment, 
    deleteComment,
    type CommentVO 
  } from '@/api/comment'
  import { ArrowDown, ArrowUp } from '@element-plus/icons-vue'
  import { ElMessage, ElMessageBox } from 'element-plus'
  import 'element-plus/theme-chalk/display.css'
  
  const route = useRoute()
  const router = useRouter()
  const userStore = useUserStore()
  const postId = Number(route.params.id)
  
  // --- 状态 ---
  const loading = ref(false)
  const post = ref<PostVO | null>(null)
  const comments = ref<CommentVO[]>([])
  const defaultAvatar = 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
  
  // 发表评论相关
  const mainCommentContent = ref('')
  const submitting = ref(false)
  
  // 回复相关
  const activeReplyId = ref<number | null>(null) // 当前正在回复哪个一级评论
  const replyContent = ref('')
  const replyPlaceholder = ref('')
  const replyTargetId = ref<number | null>(null) // 实际要回复的 parentId (可能是层主，也可能是楼中楼ID)
  const replySubmitting = ref(false)

  const formatTime = (timeStr: string | undefined) => {
        if (!timeStr) return ''
        // 将 2023-11-22T12:00:00 转换为 2023-11-22 12:00
        return timeStr.replace('T', ' ').substring(0, 16)
    }

    // 跳转到用户主页
    const goToUser = (userId: number) => {
    if (userId) {
        router.push(`/user/${userId}`)
    }
    }
  
  // --- 初始化 ---
  const initData = async () => {
    loading.value = true
    try {
      // 1. 获取帖子详情
      const postRes: any = await getPostDetail(postId)
      if (postRes.code === 0 || postRes.code === 200) {
        post.value = postRes.data
      }
      
      // 2. 获取一级评论
      await refreshComments()
    } catch (error) {
      console.error(error)
    } finally {
      loading.value = false
    }
  }
  
  const refreshComments = async () => {
    const res: any = await getCommentList(postId)
    if (res.code === 0 || res.code === 200) {
      comments.value = res.data.map((item: CommentVO) => ({
        ...item,
        showReplies: false, // 默认收起
        subComments: [],
        loadingReplies: false
      }))
    }
  }
  
  // --- 楼中楼逻辑 ---
  const fetchSubComments = async (comment: CommentVO) => {
    comment.loadingReplies = true
    try {
      // 传入 rootId (即一级评论的 ID)
      const res: any = await getSubCommentList(comment.id)
      if (res.code === 0 || res.code === 200) {
        comment.subComments = res.data
        comment.showReplies = true
      }
    } catch (error) {
      console.error(error)
    } finally {
      comment.loadingReplies = false
    }
  }
  
  // 辅助：获取被回复人的名字 (在前端简单查找)
  const getTargetName = (parentId: number, subComments: CommentVO[] = []) => {
    const target = subComments.find(c => c.id === parentId)
    return target ? target.authorName : '未知用户'
  }
  
  // --- 交互操作 ---
  
  // 1. 发表一级评论
  const submitMainComment = async () => {
    if (!mainCommentContent.value.trim()) return ElMessage.warning('请输入内容')
    
    submitting.value = true
    try {
      const res: any = await createComment({
        postId: postId,
        content: mainCommentContent.value,
        parentId: 0 // 0 代表一级评论 (视后端约定，有的可能不传)
      })
      if (res.code === 0 || res.code === 200) {
        ElMessage.success('评论成功')
        mainCommentContent.value = ''
        await refreshComments()
        // 刷新帖子详情以更新评论数
        const pRes: any = await getPostDetail(postId)
        if (pRes.data) post.value = pRes.data
      }
    } finally {
      submitting.value = false
    }
  }
  
  // 2. 打开回复框 (回复层主 或 回复楼中楼)
  // rootComment: 该楼层的层主评论对象 (一级评论)
  // targetSub: 具体的回复目标 (如果是回复层主，则为 null)
  const openReplyBox = (rootComment: CommentVO, targetSub?: CommentVO) => {
    // 如果已经打开且点击的是同一个，则关闭
    if (activeReplyId.value === rootComment.id && replyTargetId.value === (targetSub?.id || rootComment.id)) {
      activeReplyId.value = null
      return
    }
  
    activeReplyId.value = rootComment.id // 回复框挂载在一级评论下面
    replyContent.value = ''
    
    if (targetSub) {
      // 回复楼中楼
      replyTargetId.value = targetSub.id
      replyPlaceholder.value = `回复 @${targetSub.authorName}`
    } else {
      // 回复层主
      replyTargetId.value = rootComment.id
      replyPlaceholder.value = `回复 @${rootComment.authorName}`
    }
  }
  
  // 3. 提交子回复
  const submitReply = async (rootComment: CommentVO) => {
    if (!replyContent.value.trim()) return ElMessage.warning('请输入内容')
    if (!replyTargetId.value) return
  
    replySubmitting.value = true
    try {
      const res: any = await createComment({
        postId: postId,
        content: replyContent.value,
        parentId: replyTargetId.value // 传入具体的 parentId
      })
      
      if (res.code === 0 || res.code === 200) {
        ElMessage.success('回复成功')
        replyContent.value = ''
        activeReplyId.value = null // 关闭回复框
        
        // 重新加载该楼层的子评论
        await fetchSubComments(rootComment)
        // 可选：更新 childCount 显示 (简单 +1，或者依赖重新 fetch)
        // rootComment.childCount++ 
      }
    } finally {
      replySubmitting.value = false
    }
  }
  
  // 4. 删除评论
  const handleDelete = (id: number, parentComment?: CommentVO) => {
    ElMessageBox.confirm('确定删除这条评论吗？', '提示', {
      type: 'warning'
    }).then(async () => {
      const res: any = await deleteComment(id)
      if (res.code === 0 || res.code === 200) {
        ElMessage.success('删除成功')
        if (parentComment) {
          // 如果是子评论，刷新子列表
          fetchSubComments(parentComment)
        } else {
          // 如果是一级评论，刷新主列表
          refreshComments()
        }
      }
    })
  }
  
  onMounted(() => {
    initData()
  })
  </script>
  
  <style scoped lang="scss">
  .post-detail-container {
    padding-bottom: 40px;
  }
  
  .post-card {
    margin-bottom: 20px;
    min-height: 400px;
    
    .post-header {
      .post-title {
        font-size: 24px;
        margin-bottom: 12px;
      }
      .post-meta {
        color: #999;
        font-size: 13px;
        display: flex;
        align-items: center;
        gap: 12px;
      }
    }
  }
  
  .comment-card {
    .comment-input-area {
      margin-bottom: 30px;
      background: #f9f9f9;
      padding: 15px;
      border-radius: 4px;
      
      .input-actions {
        margin-top: 10px;
        text-align: right;
      }
    }
    
    .comment-item {
      display: flex;
      gap: 16px;
      padding: 20px 0;
      border-bottom: 1px solid #eee;
      
      .avatar-col {
        flex-shrink: 0;
      }
      
      .content-col {
        flex-grow: 1;
        
        .user-info {
          display: flex;
          justify-content: space-between;
          margin-bottom: 6px;
          
          .username {
            font-weight: 600;
            font-size: 14px;
            color: #333;
          }
          .time {
            color: #999;
            font-size: 12px;
          }
        }
        
        .comment-text {
          font-size: 14px;
          color: #333;
          line-height: 1.6;
          margin-bottom: 8px;
        }
        
        .action-bar {
          margin-bottom: 10px;
        }
        
        .sub-comment-wrapper {
          background-color: #f7f8fa;
          padding: 12px;
          border-radius: 4px;
          margin-top: 10px;
          
          .sub-item {
            font-size: 13px;
            margin-bottom: 8px;
            line-height: 1.5;
            
            .sub-user {
              font-weight: 600;
              color: #666;
            }
            
            .reply-text {
              margin: 0 4px;
              color: #999;
            }
            
            .target-user {
              color: #409eff;
            }
            
            .sub-content {
              color: #333;
            }
            
            .sub-actions {
              margin-top: 2px;
              font-size: 12px;
              color: #999;
              
              .sub-time {
                margin-right: 10px;
              }
            }
          }
          
          .expand-btn {
            margin-top: 8px;
            padding-top: 8px;
            border-top: 1px dashed #e0e0e0;
          }
        }
        
        .inline-reply-box {
          margin-top: 10px;
        }
      }
    }
  }
  
  .author-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 20px 0;
  }
  /* ✅ 新增：可点击的头像样式 */
.clickable-avatar {
  cursor: pointer;
  transition: transform 0.2s; /* 加个小动效更精致 */
}

.clickable-avatar:hover {
  transform: scale(1.1); /* 鼠标悬停放大一点点 */
}

/* ✅ 新增：可点击的名字样式（侧边栏） */
.clickable-name {
  cursor: pointer;
  transition: color 0.2s;
}

.clickable-name:hover {
  color: #409eff; /* 鼠标悬停变蓝 */
}
  </style>