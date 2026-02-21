<template>
    <div class="app-wrapper">
      <header class="app-header">
        <div class="header-content">
          <div class="logo" @click="$router.push('/')">
            <el-icon class="logo-icon"><School /></el-icon>
            <span>校园论坛</span>
          </div>
          
          <div class="flex-grow"></div> 
          <div class="user-actions">
            <div class="message-bell" @click="goToMessageCenter">
            <el-badge :value="unreadCount" :max="99" :hidden="unreadCount === 0" class="item">
              <el-icon :size="22"><Bell /></el-icon>
            </el-badge>
          </div>
            <el-button type="primary" round :icon="EditPen" @click="handlePublish">发布帖子</el-button>
            
            <el-dropdown class="user-dropdown" @command="handleCommand">
              <span class="el-dropdown-link">
                <el-avatar :size="32" :src="userStore.userInfo?.avatar || 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'" />
                <span class="username">{{ userStore.userInfo?.nickname || '同学' }}</span>
                <el-icon class="el-icon--right"><arrow-down /></el-icon>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                  <el-dropdown-item 
                        v-if="userStore.userInfo?.role === 'MODERATOR'" 
                        command="moderator" 
                        divided
                    >
                        板主工作台
                    </el-dropdown-item>
                  <el-dropdown-item 
                        v-if="userStore.userInfo?.role === 'ADMIN'" 
                        command="admin" 
                        divided
                    >
                        后台管理
                    </el-dropdown-item>
                  <el-dropdown-item divided command="logout">退出登录</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </div>
      </header>
  
      <main class="app-main">
        <router-view />
      </main>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, onMounted, onUnmounted } from 'vue'
  import { useRouter } from 'vue-router'
  import { useUserStore } from '@/store/userStore'
  import { School, EditPen, ArrowDown, Bell } from '@element-plus/icons-vue'
  import { getUnreadCount } from '@/api/message'
  import { ElMessage } from 'element-plus'
  
  const router = useRouter()
  const userStore = useUserStore()

  // --- 消息轮询逻辑 ---
    const unreadCount = ref(0)
    let pollTimer: any = null

    const fetchUnreadCount = async () => {
    // 只有登录状态下才轮询
    if (!userStore.token) return
    try {
        const res: any = await getUnreadCount()
        if (res.code === 0 || res.code === 200) {
            unreadCount.value = res.data
            console.log("查询未读消息")
        }
    } catch (error) {
        console.error('获取未读数失败', error)
    }
    }
    const goToMessageCenter = () => {
        router.push('/message')
    }

    // 组件挂载开始轮询
    onMounted(() => {
    fetchUnreadCount() // 立即执行一次
        pollTimer = setInterval(fetchUnreadCount, 1000) // 每1秒轮询
    })

    // 组件卸载清除定时器
    onUnmounted(() => {
        if (pollTimer) clearInterval(pollTimer)
    })
  
  const handlePublish = () => {
    router.push('/post/create')
  }
  
  const handleCommand = (command: string) => {
    if (command === 'logout') {
      userStore.logout()
    } else if (command === 'profile') {
      // router.push('/user/profile')
      // ElMessage.info('个人中心开发中...')
      router.push(`/user/${userStore.userInfo?.username}`)
    } else if (command === 'admin') {
        // 跳转到管理页
        console.log(userStore.userInfo.role)
        router.push('/admin')
    } else if(command === 'moderator') router.push('/moderator')
  }
  </script>
  
  <style scoped lang="scss">
  .app-wrapper {
    min-height: 100vh;
    background-color: #f5f7fa; // 浅灰背景，护眼
  }
  
  .app-header {
    background-color: #fff;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    position: sticky;
    top: 0;
    z-index: 100;
    
    .header-content {
      max-width: 1200px;
      margin: 0 auto;
      height: 60px;
      display: flex;
      align-items: center;
      padding: 0 20px;
      
      .logo {
        display: flex;
        align-items: center;
        font-size: 20px;
        font-weight: bold;
        color: #409eff;
        cursor: pointer;
        gap: 8px;
      }
      
      .flex-grow {
        flex-grow: 1;
      }
  
      .user-actions {
        display: flex;
        align-items: center;
        gap: 20px;
        
        .user-dropdown {
          cursor: pointer;
          .el-dropdown-link {
            display: flex;
            align-items: center;
            gap: 8px;
          }
        }
        // 新增铃铛样式
        .message-bell {
            cursor: pointer;
            display: flex;
            align-items: center;
            color: #606266;
            margin-right: 10px;
            transition: color 0.3s;
            
            &:hover {
            color: #409eff;
            }
        }
      }
    }
  }
  
  .app-main {
    max-width: 1200px;
    margin: 20px auto;
    padding: 0 20px;
  }
  </style>