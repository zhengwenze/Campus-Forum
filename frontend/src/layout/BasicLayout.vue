<template>
  <div class="app-wrapper">
    <header class="app-header">
      <div class="header-content">
        <div class="logo" @click="$router.push('/')">
          <el-icon class="logo-icon">
            <School />
          </el-icon>
          <span>校园论坛</span>
        </div>

        <div class="flex-grow"></div>
        <div class="user-actions">
          <div class="message-bell" @click="goToMessageCenter">
            <el-badge :value="unreadCount" :max="99" :hidden="unreadCount === 0" class="item">
              <el-icon :size="20">
                <Bell />
              </el-icon>
            </el-badge>
          </div>
          <button class="publish-button" @click="handlePublish">发布帖子</button>

          <div class="user-dropdown" @click="toggleDropdown">
            <div class="user-info">
              <el-avatar :size="32"
                :src="userStore.userInfo?.avatar || 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'" />
              <span class="username">{{ userStore.userInfo?.nickname || '同学' }}</span>
              <el-icon :size="16">
                <ArrowDown />
              </el-icon>
            </div>
            <div class="dropdown-menu" v-if="dropdownVisible">
              <div class="dropdown-item" @click="handleCommand('profile')">个人中心</div>
              <div class="dropdown-divider"
                v-if="userStore.userInfo?.role === 'MODERATOR' || userStore.userInfo?.role === 'ADMIN'"></div>
              <div class="dropdown-item" v-if="userStore.userInfo?.role === 'MODERATOR'"
                @click="handleCommand('moderator')">板主工作台</div>
              <div class="dropdown-item" v-if="userStore.userInfo?.role === 'ADMIN'" @click="handleCommand('admin')">
                后台管理</div>
              <div class="dropdown-divider"></div>
              <div class="dropdown-item logout" @click="handleCommand('logout')">退出登录</div>
            </div>
          </div>
        </div>
      </div>
    </header>

    <main class="app-main">
      <router-view />
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, onBeforeUnmount } from 'vue'
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
    }
  } catch (error) {
    console.error('获取未读数失败', error)
  }
}
const goToMessageCenter = () => {
  router.push('/message')
}

// --- 下拉菜单逻辑 ---
const dropdownVisible = ref(false)

const toggleDropdown = () => {
  dropdownVisible.value = !dropdownVisible.value
}

const closeDropdown = () => {
  dropdownVisible.value = false
}

// 点击外部关闭下拉菜单
const handleClickOutside = (event: MouseEvent) => {
  const dropdown = document.querySelector('.user-dropdown')
  if (dropdown && !dropdown.contains(event.target as Node)) {
    closeDropdown()
  }
}

// --- 生命周期 ---
onMounted(() => {
  fetchUnreadCount() // 立即执行一次
  pollTimer = setInterval(fetchUnreadCount, 1000) // 每1秒轮询
  document.addEventListener('click', handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  if (pollTimer) clearInterval(pollTimer)
})

const handlePublish = () => {
  router.push('/post/create')
}

const handleCommand = (command: string) => {
  closeDropdown()

  if (command === 'logout') {
    userStore.logout()
  } else if (command === 'profile') {
    router.push(`/user/${userStore.userInfo?.username}`)
  } else if (command === 'admin') {
    router.push('/admin')
  } else if (command === 'moderator') router.push('/moderator')
}
</script>

<style scoped lang="scss">
.app-wrapper {
  min-height: 100vh;
  background-color: #f5f5f7;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
    "Helvetica Neue", Arial, sans-serif;
}

.app-header {
  background-color: rgba(255, 255, 255, 0.72);
  backdrop-filter: saturate(180%) blur(20px);
  -webkit-backdrop-filter: saturate(180%) blur(20px);
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
  position: sticky;
  top: 0;
  z-index: 100;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;

  &:hover {
    background-color: rgba(255, 255, 255, 0.9);
    box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.04);
  }

  .header-content {
    max-width: 980px;
    margin: 0 auto;
    height: 44px;
    display: flex;
    align-items: center;
    padding: 0 22px;
  }

  .logo {
    display: flex;
    align-items: center;
    font-size: 17px;
    font-weight: 600;
    color: #1d1d1f;
    cursor: pointer;
    gap: 8px;
    transition: opacity 0.2s ease;

    &:hover {
      opacity: 0.75;
    }

    .logo-icon {
      color: #0071e3;
    }
  }

  .flex-grow {
    flex-grow: 1;
  }

  .user-actions {
    display: flex;
    align-items: center;
    gap: 16px;

    // 消息铃铛
    .message-bell {
      cursor: pointer;
      display: flex;
      align-items: center;
      color: #6e6e73;
      transition: color 0.2s ease, transform 0.2s ease;

      &:hover {
        color: #0071e3;
        transform: translateY(-1px);
      }

      // 穿透 el-badge 内部结构
      :deep(.el-badge) {
        display: flex;
        align-items: center;
      }
    }

    // 发布按钮（Apple 风格 pill 按钮）
    .publish-button {
      background-color: #0071e3;
      color: #fff;
      border: none;
      border-radius: 980px;
      padding: 8px 20px;
      font-size: 14px;
      font-weight: 500;
      letter-spacing: 0.01em;
      cursor: pointer;
      transition: background-color 0.2s ease, transform 0.2s ease,
        box-shadow 0.2s ease;

      &:hover {
        background-color: #0077ed;
        transform: translateY(-1px);
        box-shadow: 0 6px 16px rgba(0, 113, 227, 0.25);
      }

      &:active {
        transform: translateY(0);
        box-shadow: 0 3px 8px rgba(0, 113, 227, 0.35);
      }
    }

    // 用户下拉菜单
    .user-dropdown {
      position: relative;
      cursor: pointer;

      .user-info {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 6px 10px;
        border-radius: 20px;
        transition: background-color 0.2s ease;

        &:hover {
          background-color: rgba(0, 0, 0, 0.04);
        }

        .username {
          font-size: 14px;
          font-weight: 500;
          color: #1d1d1f;
        }
      }

      .dropdown-menu {
        position: absolute;
        top: 100%;
        right: 0;
        margin-top: 10px;
        background-color: #fff;
        border-radius: 16px;
        box-shadow: 0 12px 32px rgba(0, 0, 0, 0.12),
          0 0 0 1px rgba(0, 0, 0, 0.02);
        min-width: 180px;
        overflow: hidden;
        animation: dropdownFadeIn 0.2s ease-out;
        z-index: 1000;

        .dropdown-item {
          padding: 10px 16px;
          font-size: 14px;
          color: #1d1d1f;
          transition: background-color 0.15s ease, color 0.15s ease;
          cursor: pointer;

          &:hover {
            background-color: #f5f5f7;
            color: #0071e3;
          }

          &.logout {
            color: #ff3b30;

            &:hover {
              background-color: rgba(255, 59, 48, 0.08);
              color: #ff3b30;
            }
          }
        }

        .dropdown-divider {
          height: 1px;
          background-color: rgba(0, 0, 0, 0.06);
          margin: 6px 0;
        }
      }
    }
  }
}

.app-main {
  max-width: 980px;
  margin: 0 auto;
  padding: 32px 24px 48px;
  min-height: calc(100vh - 44px);
}

@keyframes dropdownFadeIn {
  from {
    opacity: 0;
    transform: translateY(-8px) scale(0.96);
  }

  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

// 响应式
@media (max-width: 768px) {
  .app-header {
    .header-content {
      padding: 0 16px;
    }

    .user-actions {
      gap: 10px;

      .publish-button {
        padding: 7px 16px;
        font-size: 13px;
      }

      .user-dropdown {
        .user-info {
          .username {
            display: none;
          }
        }
      }
    }
  }

  .app-main {
    padding: 24px 16px 40px;
  }
}
</style>
