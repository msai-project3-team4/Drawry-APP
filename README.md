# Drawry App - AI 기반 동화 이미지 제작 앱 🖌️📖
## 📌 프로젝트 개요
<p>Drawry App은 AI 기반으로 동화 이미지를 제작하는 Flutter 애플리케이션입니다.</p>
<p>사용자가 시간, 장소, 행동으로 프롬프트 선택한 후 스케치 기능을 통해 장면을 직접 그릴 수 있으며,</p>
<p>AI가 이를 해석하여 멋진 동화 이미지를 생성해줍니다.</p>

### <p>🎨 주요 기능:</p>
<p>동화책 선택 & 캐릭터 설정</p>
<p>시간, 장소, 행동 프롬프트 선택 후 AI 기반 이미지 생성</p>
<p>손으로 직접 스케치하여 원하는 장면 표현</p>
<p>ControlNet 기반 AI 모델을 활용한 이미지 생성</p>
<p>Azure Cloud 기반 메인 백엔드 연동 FastAPI</p>
<p>Azure Cloud 기반 AI 백엔드 연동 Flask</p>

## 🚀 기술 스택
<p><b>📱 Frontend (Flutter)</b></p>
<p>Flutter: UI 개발 및 애니메이션</p>
<p>Dart: Flutter 애플리케이션 로직 개발</p>
<p>HTTP: FastAPI 백엔드와 API 통신</p>
<p>CustomPainter: 사용자 스케치 기능 구현</p>

<p><b>⚙️ Backend</b></p>
<p>FastAPI: 메인 API 서버 (Python)</p>
<p>Flask: AI 이미지 생성 API 서버</p>
<p>MongoDB: 동화 진행 상태 저장</p>
<p>NGINX: API Gateway 및 보안 강화</p>
<p>참고자료: https://github.com/msai-project3-team4/Drawry-APP-BackEnd</p>
<p><b>☁️ Cloud & DevOps</p></b>
<p>Azure VM: FastAPI & AI API 서버 운영</p>
<p>Docker: 백엔드 컨테이너화 배포</p>
<p>NGINX Reverse Proxy: AI API 트래픽 관리</p>

## 📖 주요 기능 상세
<p>1️⃣ 동화책 & 캐릭터 선택</p>
<p>✅ 사용자는 여러 동화책 중에서 하나를 선택하고, 등장할 캐릭터를 고를 수 있습니다.</p>
<p>✅ MongoDB에 사용자의 선택 정보를 저장하며, 이후 AI 생성에 활용됩니다.</p>
<hr>
<p>2️⃣ 시간, 장소, 행동 프롬프선택</p>
<p>✅ 동화의 장면을 설정하기 위해 시간, 장소, 행동을 선택하는 과정이 있습니다.</p>
<p>✅ 선택된 데이터는 API를 통해 저장되며, 스케치 단계에서 활용됩니다.</p>
<hr>
<p>3️⃣ 스케치 기능</p>
<p>✅ 사용자가 손으로 직접 장면을 그릴 수 있는 UI 제공 (CustomPainter 사용)</p>
<p>✅ 지우개 모드 / 펜 모드 / 색상 선택 기능 포함</p>
<p>✅ Flutter에서 터치 좌표를 기반으로 실시간으로 그림을 그릴 수 있도록 구현</p>
<hr>
<p>4️⃣ AI 이미지 생성</p>
<p>✅ 사용자가 그린 스케치를 ControlNet AI 모델을 이용하여 고품질 일러스트로 변환</p>
<p>✅ Azure GPU VM에 배포된 Flask AI 서버에서 이미지 생성 처리</p>
<p>✅ 결과 이미지가 Flutter UI에서 표시됨</p>
<hr>

## 🔒 보안 강화 & 운영 경험
<p>✅ API 인증 강화: JWT 기반 인증 시스템 적용</p>
<p>✅ NGINX 보안 강화: 해킹 시도 감지 후 서버 보안 업데이트</p>

## 👨‍💻 개발자
<p><b>이름: 남두현[풀스택, DevOps]</p></b>
<p>이메일: kndh2914@gmail.com</p>
<p>GitHub: https://github.com/namduhus</p>
