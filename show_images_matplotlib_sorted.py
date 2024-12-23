import matplotlib.pyplot as plt
import os
import time
from PIL import Image

# 设置图片目录
data_images_dir = './data_images'

# 获取目录下的所有图片文件
image_files = [f for f in os.listdir(data_images_dir) if f.endswith(('.png', '.jpg', '.jpeg'))]

# 自定义排序函数
def sort_by_number(filename):
    number_part = ''.join(filter(str.isdigit, filename))
    return int(number_part) if number_part else float('inf')

# 对图片文件进行排序
sorted_image_files = sorted(image_files, key=sort_by_number)

# 确保图片文件列表不为空
if not sorted_image_files:
    print("没有找到图片文件。")
else:
    # 遍历所有排序后的图片文件
    for image_file in sorted_image_files:
        # 构建完整的图片路径
        image_path = os.path.join(data_images_dir, image_file)
        
        # 使用Pillow打开图片
        try:
            img = Image.open(image_path)
            # 转换为灰度图
            img = img.convert('L')
            
            # 使用matplotlib显示图片
            plt.imshow(img, cmap='gray')
            plt.axis('off')  # 关闭坐标轴
            plt.title(image_file)
            plt.pause(1.5)  # 暂停1.5秒
            plt.close()  # 关闭图片窗口
        except IOError:
            print(f"无法读取图片文件：{image_path}")