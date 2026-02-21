<template>
    <div class="forum-container">
      <el-row :gutter="20">
        <el-col :span="17" :xs="24">
          <el-card class="post-list-card" shadow="never">
            
            <div class="toolbar">
              <el-tabs v-model="activeTab" @tab-change="handleTabChange" class="custom-tabs">
                <el-tab-pane label="全部" :name="0"></el-tab-pane>
                <el-tab-pane 
                  v-for="board in boardList" 
                  :key="board.id" 
                  :label="board.name" 
                  :name="board.id"
                >
                </el-tab-pane>
              </el-tabs>
  
              <div class="search-box">
                <el-input 
                  v-model="queryParams.keyword" 
                  placeholder="搜索帖子..." 
                  prefix-icon="Search"
                  clearable
                  @clear="handleSearch"
                  @keyup.enter="handleSearch"
                  style="width: 200px"
                />
                <el-button :icon="Search" circle @click="handleSearch" style="margin-left: 8px" />
              </div>
            </div>
  
            <div class="post-items" v-loading="loading">
              <el-empty v-if="postList.length === 0 && !loading" description="暂无相关帖子" />
  
              <div v-for="post in postList" :key="post.id" class="post-item" @click="goToDetail(post.id)">
                <h3 class="post-title">
                  <el-tag size="small" effect="plain" class="board-tag" v-if="post.boardName">
                    {{ post.boardName }}
                  </el-tag>
                  {{ post.title }}
                </h3>
                <p class="post-summary">{{ stripHtml(post.content).substring(0, 100) }}...</p>
                
                <div class="post-meta">
                  <span class="meta-item">
                     <el-avatar :size="20" :src="post.authorAvatar || defaultAvatar" />
                     <span class="author-name">{{ post.authorName || '匿名用户' }}</span>
                  </span>
                  <span class="meta-divider">|</span>
                  <span class="meta-item">{{ formatTime(post.createTime) }}</span>
                  
                  <div class="post-stats">
                     <span class="stat-item"><el-icon><View /></el-icon> {{ post.viewCount }}</span>
                     <span class="stat-item"><el-icon><ChatLineRound /></el-icon> {{ post.replyCount }}</span>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="pagination-container" v-if="total > 0">
               <el-pagination 
                 background 
                 layout="prev, pager, next" 
                 :total="total" 
                 :page-size="queryParams.pageSize"
                 :current-page="queryParams.pageNum"
                 @current-change="handlePageChange"
               />
            </div>
          </el-card>
        </el-col>
  
        <el-col :span="7" class="hidden-xs-only">
          <el-card class="sidebar-card welcome-card" shadow="hover">
             <div class="welcome-header">
               <h3>👋 欢迎来到校园论坛</h3>
               <p>发现有趣的内容，分享你的校园生活</p>
             </div>
          </el-card>
  
          <el-card class="sidebar-card" shadow="hover">
            <template #header>
              <div class="card-header">
                <span>📌 板块导航</span>
              </div>
            </template>
            <div class="board-tags">
               <el-tag 
                 v-for="board in boardList" 
                 :key="board.id" 
                 class="topic-tag" 
                 effect="light"
                 @click="activeTab = board.id; handleTabChange(board.id)"
               >
                 {{ board.name }}
               </el-tag>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, reactive, onMounted } from 'vue'
  import { useRouter } from 'vue-router'
  import { View, ChatLineRound, Search } from '@element-plus/icons-vue' // ✅ 引入 Search 图标
  import { getPostList, type PostVO, type PostQuery } from '@/api/post'
  import { getBoardList, type Board } from '@/api/board'
  import 'element-plus/theme-chalk/display.css'
  
  const router = useRouter()
  const loading = ref(false)
  const activeTab = ref(0) 
  const boardList = ref<Board[]>([]) 
  const postList = ref<PostVO[]>([]) 
  const total = ref(0)
  const defaultAvatar = 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
  
  // ✅ 修改：在 queryParams 中添加 keyword
  const queryParams = reactive<PostQuery>({
    pageNum: 1,
    pageSize: 10,
    boardId: undefined,
    keyword: '' // 新增
  })
  
  const fetchBoards = async () => {
    try {
      const res: any = await getBoardList()
      if (res.code === 0 || res.code === 200) {
        boardList.value = res.data
      }
    } catch (error) {
      console.error(error)
    }
  }
  
  const fetchPosts = async () => {
    loading.value = true
    try {
      const params = { ...queryParams }
      if (activeTab.value === 0) {
        delete params.boardId
      } else {
        params.boardId = activeTab.value
      }
      // 注意：后端接口如果 keyword 为空字符串可能会过滤为空，通常不需要特殊处理，
      // 但如果后端严格判断 null，这里 params 已经是正确的了。
  
      const res: any = await getPostList(params)
      if (res.code === 0 || res.code === 200) {
        postList.value = res.data.records
        total.value = res.data.total
      }
    } catch (error) {
      console.error(error)
    } finally {
      loading.value = false
    }
  }
  
  // ✅ 新增：处理搜索
  const handleSearch = () => {
    queryParams.pageNum = 1 // 搜索时重置回第一页
    fetchPosts()
  }
  
  const handleTabChange = (name: any) => {
    queryParams.pageNum = 1
    queryParams.boardId = name === 0 ? undefined : name
    // 切换板块时，通常保留 keyword 还是清空？
    // 这里的逻辑保留了 keyword，意味着是“在该板块下搜索”
    fetchPosts()
  }
  
  const handlePageChange = (page: number) => {
    queryParams.pageNum = page
    fetchPosts()
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
  
  const goToDetail = (id: number) => {
    router.push(`/post/${id}`)
  }
  
  const stripHtml = (html: string) => {
    if (!html) return ''
    return html.replace(/<[^>]*>?/gm, '')
  }
  
  const formatTime = (timeStr: string) => {
    if (!timeStr) return ''
    return timeStr.replace('T', ' ').substring(0, 16)
  }
  
  onMounted(() => {
    fetchBoards()
    fetchPosts()
  })
  </script>
  
  <style scoped lang="scss">
  .post-list-card {
    min-height: 600px;
    :deep(.el-card__body) {
      padding: 0 20px;
    }
  }
  
  /* ✅ 新增：Toolbar 样式，让 Tabs 和搜索框并排 */
  .toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 2px solid #f0f0f0; /* el-tabs 自带下划线可能不够长，这里手动补一个视觉分割 */
    margin-bottom: 10px;
    padding-right: 10px;
  
    .custom-tabs {
      flex: 1;
      /* 去掉 el-tabs 默认的底部 margin */
      :deep(.el-tabs__header) {
        margin: 0;
        border-bottom: none; 
      }
      :deep(.el-tabs__nav-wrap::after) {
        display: none; /* 隐藏 el-tabs 默认的灰色横线，用 toolbar 的 border 代替 */
      }
    }
  
    .search-box {
      display: flex;
      align-items: center;
    }
  }
  
  .post-item {
    padding: 20px 0;
    border-bottom: 1px solid #f0f0f0;
    cursor: pointer;
    transition: all 0.2s;
    
    &:hover {
      background-color: #fafafa;
    }
    
    .post-title {
      font-size: 18px;
      font-weight: 600;
      color: #333;
      margin-bottom: 8px;
      display: flex;
      align-items: center;
      gap: 8px;
  
      .board-tag {
        font-weight: normal;
      }
    }
    
    .post-summary {
      color: #666;
      font-size: 14px;
      margin-bottom: 12px;
      line-height: 1.5;
    }
    
    .post-meta {
      display: flex;
      align-items: center;
      font-size: 13px;
      color: #999;
      
      .meta-item {
        display: flex;
        align-items: center;
        gap: 6px;
      }
      
      .meta-divider {
        margin: 0 10px;
        color: #eee;
      }
      
      .post-stats {
        margin-left: auto;
        display: flex;
        gap: 16px;
      }
    }
  }
  
  .sidebar-card {
    margin-bottom: 20px;
    .topic-tag {
      margin-right: 8px;
      margin-bottom: 8px;
      cursor: pointer;
      transition: all 0.3s;
      &:hover { transform: translateY(-2px); }
    }
  }
  
  .welcome-card {
    background: linear-gradient(135deg, #e3f2fd 0%, #fff 100%);
  }
  
  .pagination-container {
    padding: 20px 0;
    display: flex;
    justify-content: center;
  }
  </style>