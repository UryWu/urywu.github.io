import pyautogui
import time

# 设置点击间隔时间为5秒
click_interval = 5  # 5 seconds

# 设置循环总时间为1小时，即3600秒
total_duration = 3600  # 1 hour in seconds

# 获取屏幕尺寸
screen_width, screen_height = pyautogui.size()

# 计算屏幕中央的坐标
center_x = screen_width // 2
center_y = screen_height // 2

# 当前时间
start_time = time.time()

# 循环，直到达到1小时
while time.time() - start_time < total_duration:
    # 模拟点击屏幕中央
    pyautogui.click(center_x, center_y)
    
    # 等待5秒
    time.sleep(click_interval)

print("屏幕点击操作完成。")