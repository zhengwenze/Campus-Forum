<template>
    <div class="admin-container">
      <el-card shadow="never">
        <template #header>
          <div class="card-header">
            <span class="title">🛡️ 管理员控制台</span>
          </div>
        </template>
  
        <el-tabs v-model="activeTab" class="admin-tabs">
          
          <el-tab-pane label="板块管理" name="board">
            <div class="tab-action-bar">
              <el-button type="primary" :icon="Plus" @click="dialogVisible = true">新增板块</el-button>
            </div>
            
            <el-table :data="boardList" style="width: 100%" v-loading="boardLoading" border stripe>
              <el-table-column prop="id" label="ID" width="80" />
              <el-table-column label="图标" width="80" align="center">
                <template #default="scope">
                  <span style="font-size: 20px">{{ scope.row.icon || '📦' }}</span>
                </template>
              </el-table-column>
              <el-table-column prop="name" label="板块名称" width="150" font-weight="bold" />
              <el-table-column prop="description" label="描述" />
              <el-table-column prop="sort" label="排序权重" width="100" align="center" sortable />
              <el-table-column label="管理设置" width="140" align="center">
                <template #default="scope">
                  <el-button 
                    type="primary" 
                    link 
                    size="small" 
                    @click="handleOpenAppoint(scope.row)"
                  >
                    <el-icon><UserFilled /></el-icon> 任命板主
                  </el-button>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="120" fixed="right" align="center">
                <template #default="scope">
                  <el-button 
                    type="danger" 
                    size="small" 
                    :icon="Delete" 
                    plain
                    @click="handleDeleteBoard(scope.row)"
                  >
                    删除
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-tab-pane>
  
          <el-tab-pane label="帖子管理" name="post">
             <div class="tab-action-bar">
                <div class="filter-row">
                    <el-input 
                        v-model="postKeyword" 
                        placeholder="搜索帖子标题" 
                        style="width: 300px; margin-right: 15px" 
                        clearable
                        @clear="handlePostSearch"
                        @keyup.enter="handlePostSearch"
                    >
                        <template #append>
                        <el-button :icon="Search" @click="handlePostSearch" />
                        </template>
                    </el-input>
                    <el-alert title="提示：置顶操作会立即生效，删除操作不可恢复。" type="info" show-icon :closable="false" />
                </div>
             </div>
  
             <el-table :data="postList" style="width: 100%" v-loading="postLoading" border>
               <el-table-column prop="id" label="ID" width="80" />
               <el-table-column label="标题" min-width="300">
                 <template #default="scope">
                   <el-link type="primary" :href="`/post/${scope.row.id}`" target="_blank">
                      {{ scope.row.title }}
                   </el-link>
                 </template>
               </el-table-column>
               <el-table-column prop="authorName" label="作者" width="120" />
               <el-table-column prop="boardName" label="所属板块" width="120" />
               <el-table-column prop="createTime" label="发布时间" width="180">
                 <template #default="scope">{{ formatTime(scope.row.createTime) }}</template>
               </el-table-column>
               <el-table-column label="管理操作" width="200" fixed="right">
                 <template #default="scope">
                   <el-button 
                     size="small" 
                     type="warning" 
                     plain
                     :icon="Top"
                     @click="handleTopPost(scope.row)"
                   >
                     置顶/取消
                   </el-button>
                   <el-button 
                     size="small" 
                     type="danger" 
                     :icon="Delete"
                     @click="handleDeletePost(scope.row)"
                   >
                     删除
                   </el-button>
                 </template>
               </el-table-column>
             </el-table>
  
             <div class="pagination-box">
               <el-pagination 
                 background 
                 layout="prev, pager, next" 
                 :total="postTotal" 
                 :page-size="postPageSize"
                 @current-change="handlePostPageChange"
               />
             </div>
          </el-tab-pane>
  
        </el-tabs>
      </el-card>
  
      <el-dialog v-model="dialogVisible" title="新增板块" width="500px">
        <el-form :model="boardForm" label-width="80px">
          <el-form-item label="板块名称">
            <el-input v-model="boardForm.name" placeholder="例如：学习交流" />
          </el-form-item>
          <el-form-item label="板块描述">
            <el-input v-model="boardForm.description" type="textarea" placeholder="板块的简单介绍" />
          </el-form-item>
          <el-form-item label="图标(Emoji)">
            <el-input v-model="boardForm.icon" placeholder="例如：📚" style="width: 100px" />
          </el-form-item>
          <el-form-item label="排序权重">
            <el-input-number v-model="boardForm.sort" :min="0" :max="999" />
            <div class="form-tip">数字越小越靠前</div>
          </el-form-item>
        </el-form>
        <template #footer>
          <span class="dialog-footer">
            <el-button @click="dialogVisible = false">取消</el-button>
            <el-button type="primary" @click="handleSubmitBoard" :loading="submitting">确定新增</el-button>
          </span>
        </template>
      </el-dialog>
  
      <el-dialog v-model="userSelectVisible" title="任命板块管理员" width="700px">
        <div style="margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center;">
          <span style="font-size: 14px; color: #666;">
            当前正在为板块 <el-tag>{{ currentBoard?.name }}</el-tag> 选择板主
          </span>
          <el-button type="danger" plain size="small" @click="handleRevoke">
            撤销当前板主
          </el-button>
        </div>
  
        <div style="margin-bottom: 15px; display: flex; gap: 10px;">
          <el-input 
            v-model="userKeyword" 
            placeholder="搜索用户名/昵称" 
            clearable 
            @clear="fetchUserList"
            @keyup.enter="fetchUserList"
          >
             <template #append>
               <el-button :icon="Search" @click="fetchUserList" />
             </template>
          </el-input>
        </div>
  
        <el-table :data="userList" v-loading="userLoading" border height="300px">
          <el-table-column prop="id" label="ID" width="80" />
          <el-table-column label="头像" width="70" align="center">
            <template #default="scope">
               <el-avatar :size="30" :src="scope.row.avatar || defaultAvatar" />
            </template>
          </el-table-column>
          <el-table-column prop="username" label="用户名" />
          <el-table-column prop="nickname" label="昵称" />
          <el-table-column prop="role" label="角色" width="100">
             <template #default="scope">
                <el-tag size="small" :type="scope.row.role === 'admin' ? 'danger' : (scope.row.role === 'moderator' ? 'warning' : 'info')">
                  {{ scope.row.role }}
                </el-tag>
             </template>
          </el-table-column>
          <el-table-column label="操作" width="100" align="center">
            <template #default="scope">
              <el-button type="primary" size="small" @click="confirmAppoint(scope.row)">选择</el-button>
            </template>
          </el-table-column>
        </el-table>
  
        <div style="margin-top: 15px; display: flex; justify-content: flex-end;">
           <el-pagination 
             background 
             layout="prev, pager, next" 
             :total="userTotal" 
             :page-size="10" 
             @current-change="handleUserPageChange"
           />
        </div>
      </el-dialog>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, reactive, onMounted } from 'vue'
  import { Plus, Delete, Top, UserFilled, Search } from '@element-plus/icons-vue'
  import { ElMessage, ElMessageBox } from 'element-plus'
  import { getBoardList } from '@/api/board'
  import { getPostList } from '@/api/post'
  import { getUserList, type UserVO } from '@/api/user' // 引入用户查询接口
  import { addBoard, deleteBoard, deletePostAdmin, toggleTopPost, appointModerator } from '@/api/admin'
  
  const activeTab = ref('board')
  const defaultAvatar = 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
  
  // --- 板块管理 ---
  const boardList = ref([])
  const boardLoading = ref(false)
  const dialogVisible = ref(false)
  const submitting = ref(false)
  const boardForm = reactive({ name: '', description: '', icon: '', sort: 0 })
  const postKeyword = ref('')
  
  // --- 帖子管理 ---
  const postList = ref([])
  const postLoading = ref(false)
  const postTotal = ref(0)
  const postPageNum = ref(1)
  const postPageSize = ref(10)
  
  // --- 任命板主相关 ---
  const userSelectVisible = ref(false)
  const currentBoard = ref<any>(null)
  const userList = ref<UserVO[]>([])
  const userLoading = ref(false)
  const userKeyword = ref('')
  const userTotal = ref(0)
  const userPageNum = ref(1)
  
  // --- 方法：板块 ---
  const fetchBoards = async () => {
    boardLoading.value = true
    try {
      const res: any = await getBoardList()
      if (res.code === 0 || res.code === 200) boardList.value = res.data
    } finally { boardLoading.value = false }
  }
  
  const handleSubmitBoard = async () => {
    if(!boardForm.name) return ElMessage.warning('请输入板块名称')
    submitting.value = true
    try {
      const res: any = await addBoard(boardForm)
      if (res.code === 0 || res.code === 200) {
        ElMessage.success('添加成功')
        dialogVisible.value = false
        boardForm.name = ''; boardForm.description = ''; boardForm.icon = ''; boardForm.sort = 0
        fetchBoards()
      }
    } finally { submitting.value = false }
  }
  
  const handleDeleteBoard = (row: any) => {
    ElMessageBox.confirm(`确定要删除板块【${row.name}】吗？删除后不可恢复！`, '警告', {
      type: 'warning', confirmButtonText: '确定删除', confirmButtonClass: 'el-button--danger'
    }).then(async () => {
      const res: any = await deleteBoard(row.id)
      if (res.code === 0 || res.code === 200) { ElMessage.success('删除成功'); fetchBoards() }
    })
  }
  
  // --- 方法：帖子 ---
  const fetchPosts = async () => {
    postLoading.value = true
    try {
      const res: any = await getPostList({ pageNum: postPageNum.value, pageSize: postPageSize.value, keyword: postKeyword.value })
      if (res.code === 0 || res.code === 200) {
        postList.value = res.data.records
        postTotal.value = res.data.total
      }
    } finally { postLoading.value = false }
  }
  const handlePostSearch = () => {
    postPageNum.value = 1 // 搜索时重置为第一页
    fetchPosts()
  }
  const handlePostPageChange = (page: number) => { postPageNum.value = page; fetchPosts() }
  const handleTopPost = async (row: any) => {
    try {
      const res: any = await toggleTopPost(row.id)
      if (res.code === 0 || res.code === 200) { ElMessage.success('操作成功'); fetchPosts() }
    } catch(e) {}
  }
  const handleDeletePost = (row: any) => {
    ElMessageBox.confirm('确定要强制删除该帖子吗？', '管理员操作', { type: 'warning' })
      .then(async () => {
        const res: any = await deletePostAdmin(row.id)
        if (res.code === 0 || res.code === 200) { ElMessage.success('帖子已删除'); fetchPosts() }
      })
  }
  
  // --- 方法：任命板主 ---
  const handleOpenAppoint = (board: any) => {
    currentBoard.value = board
    userSelectVisible.value = true
    // 打开时重置搜索并加载列表
    userKeyword.value = ''
    userPageNum.value = 1
    fetchUserList()
  }
  
  const fetchUserList = async () => {
    userLoading.value = true
    try {
      const res: any = await getUserList({
        pageNum: userPageNum.value,
        pageSize: 10,
        keyword: userKeyword.value
      })
      if (res.code === 0 || res.code === 200) {
        userList.value = res.data.records
        userTotal.value = res.data.total
      }
    } finally {
      userLoading.value = false
    }
  }
  
  const handleUserPageChange = (page: number) => {
    userPageNum.value = page
    fetchUserList()
  }
  
  // 确认任命
  const confirmAppoint = (user: UserVO) => {
    ElMessageBox.confirm(`确定要任命【${user.nickname}】为【${currentBoard.value.name}】的板主吗？`, '任命确认', {
      type: 'warning'
    }).then(async () => {
      const res: any = await appointModerator({
        boardId: currentBoard.value.id,
        userId: user.id
      })
      if (res.code === 0 || res.code === 200) {
        ElMessage.success(`已任命 ${user.nickname} 为板主`)
        userSelectVisible.value = false
        // 可能需要刷新板块列表
        fetchBoards()
      }
    })
  }
  
  // 撤销板主 (传入0)
  const handleRevoke = () => {
    ElMessageBox.confirm(`确定要撤销当前板块的板主吗？`, '撤销确认', {
      type: 'warning'
    }).then(async () => {
      const res: any = await appointModerator({
        boardId: currentBoard.value.id,
        userId: 0 // 0 代表撤销
      })
      if (res.code === 0 || res.code === 200) {
        ElMessage.success('已撤销板主')
        userSelectVisible.value = false
      }
    })
  }
  
  const formatTime = (time: string) => {
    if (!time) return ''
    return time.replace('T', ' ').substring(0, 16)
  }
  
  onMounted(() => {
    fetchBoards()
    fetchPosts()
  })
  </script>
  
  <style scoped lang="scss">
  .admin-container { max-width: 1200px; margin: 20px auto; }
  .card-header { font-size: 18px; font-weight: bold; }
  .tab-action-bar { margin-bottom: 20px; display: flex; justify-content: flex-start; }
  .form-tip { font-size: 12px; color: #999; margin-left: 10px; display: inline-block; }
  .pagination-box { margin-top: 20px; display: flex; justify-content: center; }
  .filter-row {
    display: flex;
    align-items: center;
  }
  </style>