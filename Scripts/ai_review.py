import os
import sys
from google import genai

API_KEY = os.getenv('GEMINI_API_KEY')
COMMENT_FILE_PATH = "review_comment.txt"

def review_code(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    client = genai.Client(api_key=API_KEY)
    response = client.models.generate_content(
        model="gemini-2.0-flash", contents=f"당신은 iOS 시니어 개발자입니다. 아래의 코드를 리뷰하고 건설적인 피드백을 제시하세요:\n\n{content}"
    )

    return response.text

if __name__ == "__main__":
    pr_base = sys.argv[1]
    pr_head = sys.argv[2]
    
    # 변경된 파일 목록 가져오기
    changed_files = os.popen(f"git diff --name-only {pr_base} {pr_head}").read().strip().split("\n")
    
    review_results = []
    for file in changed_files:
        if not os.path.exists(file):  # 파일이 존재하는지 확인
            print(f"Deleted: {file}")
            continue

        if file.endswith((".swift")):  # 리뷰할 파일 확장자 필터링
            print(f"Reviewing {file}...")
            review_results.append(f"### `{file}`\n{review_code(file)}\n")
    
    with open(COMMENT_FILE_PATH, "w", encoding="utf-8") as f:
        f.write("\n".join(review_results))
        print(f"saved to {COMMENT_FILE_PATH}")
