<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>تطبيق الإسلام - المواقيت، القبلة، والقرآن</title>
    <style>
        :root {
            --primary-color: #1b4332;
            --accent-color: #d4af37;
            --bg-color: #f8f9fa;
            --card-bg: #ffffff;
            --text-color: #2b2b2b;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 0;
        }

        header {
            background-color: var(--primary-color);
            color: white;
            text-align: center;
            padding: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        nav {
            display: flex;
            justify-content: center;
            background-color: #2d6a4f;
        }

        nav button {
            background: none;
            border: none;
            color: white;
            padding: 12px 24px;
            font-size: 1rem;
            cursor: pointer;
            transition: 0.3s;
        }

        nav button.active, nav button:hover {
            background-color: var(--accent-color);
            color: var(--primary-color);
            font-weight: bold;
        }

        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 0 15px;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        /* تصميم مواقيت الصلاة */
        .prayer-card {
            background: var(--card-bg);
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            border-right: 5px solid var(--primary-color);
        }

        .prayer-name { font-size: 1.2rem; font-weight: bold; }
        .prayer-time { font-size: 1.2rem; color: var(--primary-color); }

        /* تصميم البوصلة والقبلة */
        .compass-container {
            text-align: center;
            margin-top: 30px;
        }

        .compass {
            width: 220px;
            height: 220px;
            border: 8px solid var(--primary-color);
            border-radius: 50%;
            margin: 20px auto;
            position: relative;
            background: white;
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
        }

        .qibla-pointer {
            width: 6px;
            height: 100px;
            background: red;
            position: absolute;
            top: 10px;
            left: calc(50% - 3px);
            transform-origin: bottom center;
            transition: transform 0.5s ease-out;
            border-radius: 3px;
        }

        .qibla-pointer::after {
            content: '🕋';
            position: absolute;
            top: -20px;
            left: -10px;
            font-size: 20px;
        }

        /* تصميم القرآن الكريم */
        .quran-controls {
            margin-bottom: 20px;
            text-align: center;
        }

        select {
            padding: 10px;
            font-size: 1rem;
            border-radius: 5px;
            border: 1px solid #ccc;
            width: 100%;
            max-width: 300px;
        }

        .surah-container {
            background: var(--card-bg);
            padding: 25px;
            border-radius: 10px;
            line-height: 2.2;
            font-size: 1.3rem;
            text-align: justify;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .ayah {
            display: inline;
        }

        .ayah-number {
            color: var(--accent-color);
            font-weight: bold;
            margin: 0 5px;
        }
    </style>
</head>
<body>

    <header>
        <h1>التطبيق الإسلامي الشامل</h1>
    </header>

    <nav>
        <button class="nav-btn active" onclick="switchTab('prayers')">مواقيت الصلاة</button>
        <button class="nav-btn" onclick="switchTab('qibla')">اتجاه القبله</button>
        <button class="nav-btn" onclick="switchTab('quran')">القرآن الكريم</button>
    </nav>

    <div class="container">
        
        <!-- قسم مواقيت الصلاة -->
        <section id="prayers" class="tab-content active">
            <h2 style="text-align: center;" id="location-name">جاري تحديد الموقع...</h2>
            <div id="prayer-list">
                <p style="text-align:center;">جاري تحميل مواقيت الصلاة...</p>
            </div>
        </section>

        <!-- قسم اتجاه القبلة -->
        <section id="qibla" class="tab-content">
            <div class="compass-container">
                <h2>اتجاه القبلة</h2>
                <p id="qibla-degree">جاري حساب الزاوية...</p>
                <div class="compass">
                    <div class="qibla-pointer" id="pointer"></div>
                </div>
                <small>ملاحظة: للحصول على أدق نتيجة في الجوال، قم بالسماح للوصول للموقع والبوصلة.</small>
            </div>
        </section>

        <!-- قسم القرآن الكريم -->
        <section id="quran" class="tab-content">
            <div class="quran-controls">
                <select id="surah-select" onchange="loadSurah(this.value)">
                    <option value="">اختر السورة...</option>
                </select>
            </div>
            <div class="surah-container" id="surah-content">
                <p style="text-align: center; color: #777;">الرجاء اختيار سورة من القائمة لأعلاه لقراءتها.</p>
            </div>
        </section>

    </div>

    <script>
        // --- 1. إدارة التنقل بين الأقسام ---
        function switchTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
            document.querySelectorAll('.nav-btn').forEach(btn => btn.classList.remove('active'));
            
            document.getElementById(tabId).classList.add('active');
            event.target.classList.add('active');
        }

        // --- 2. جلب مواقيت الصلاة والحسابات ---
        function initLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(position => {
                    const lat = position.coords.latitude;
                    const lng = position.coords.longitude;
                    
                    fetchPrayerTimes(lat, lng);
                    calculateQibla(lat, lng);
                }, () => {
                    // موقع افتراضي (مكة المكرمة) في حال رفض الإذن
                    fetchPrayerTimes(21.4225, 39.8262);
                    calculateQibla(21.4225, 39.8262);
                    document.getElementById('location-name').innerText = "مكة المكرمة (الموقع الافتراضي)";
                });
            } else {
                alert("المتصفح لا يدعم تحديد الموقع الجغرافي.");
            }
        }

        function fetchPrayerTimes(lat, lng) {
            fetch(`https://api.aladhan.com/v1/timings?latitude=${lat}&longitude=${lng}&method=4`)
                .then(res => res.json())
                .then(data => {
                    const timings = data.data.timings;
                    const prayerNames = {
                        Fajr: "الفجر",
                        Sunrise: "الشروق",
                        Dhuhr: "الظهر",
                        Asr: "العصر",
                        Maghrib: "المغرب",
                        Isha: "العشاء"
                    };

                    let html = '';
                    for (let key in prayerNames) {
                        html += `
                            <div class="prayer-card">
                                <span class="prayer-name">${prayerNames[key]}</span>
                                <span class="prayer-time">${timings[key]}</span>
                            </div>
                        `;
                    }
                    document.getElementById('prayer-list').innerHTML = html;
                    if(!document.getElementById('location-name').innerText.includes("الافتراضي")) {
                        document.getElementById('location-name').innerText = "مواقيت الصلاة لموقعك الحالي";
                    }
                });
        }

        // --- 3. حساب اتجاه القبلة ---
        function calculateQibla(lat, lng) {
            const kaabaLat = 21.422487;
            const kaabaLng = 39.826206;

            const phiK = kaabaLat * Math.PI / 180;
            const lambdaK = kaabaLng * Math.PI / 180;
            const phi = lat * Math.PI / 180;
            const lambda = lng * Math.PI / 180;

            const qiblaAngle = Math.atan2(
                Math.sin(lambdaK - lambda),
                Math.cos(phi) * Math.tan(phiK) - Math.sin(phi) * Math.cos(lambdaK - lambda)
            ) * 180 / Math.PI;

            const finalAngle = (qiblaAngle + 360) % 360;
            
            document.getElementById('qibla-degree').innerText = `زاوية القبلة: ${Math.round(finalAngle)}° من الشمال`;
            document.getElementById('pointer').style.transform = `rotate(${finalAngle}deg)`;
        }

        // --- 4. جلب وعرض القرآن الكريم ---
        function initQuran() {
            fetch('https://api.alquran.cloud/v1/surah')
                .then(res => res.json())
                .then(data => {
                    const select = document.getElementById('surah-select');
                    data.data.forEach(surah => {
                        let option = document.createElement('option');
                        option.value = surah.number;
                        option.textContent = `${surah.number}. ${surah.name}`;
                        select.appendChild(option);
                    });
                });
        }

        function loadSurah(surahNumber) {
            if (!surahNumber) return;
            const container = document.getElementById('surah-content');
            container.innerHTML = '<p style="text-align:center;">جاري تحميل السورة...</p>';

            fetch(`https://api.alquran.cloud/v1/surah/${surahNumber}`)
                .then(res => res.json())
                .then(data => {
                    let html = '';
                    data.data.ayahs.forEach(ayah => {
                        html += `<span class="ayah">${ayah.text} <span class="ayah-number">﴿${ayah.numberInSurah}﴾</span></span> `;
                    });
                    container.innerHTML = html;
                });
        }

        // تشغيل الوظائف عند فتح الصفحة
        window.onload = () => {
            initLocation();
            initQuran();
        };
    </script>
</body>
</html>