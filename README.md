# 🛍️ Lace Hub - E-Commerce App

Lace Hub એ Flutter અને Firebase નો ઉપયોગ કરીને બનાવેલી એક સંપૂર્ણ ઈ-કોમર્સ એપ્લિકેશન છે. જેમાં એડમિન પોતાના પ્રોડક્ટ ઉમેરી શકે છે અને ગ્રાહકો WhatsApp દ્વારા ઈન્ક્વાયરી કે ઓર્ડર કરી શકે છે.

## 🚀 મુખ્ય ફીચર્સ (Key Features)

*   *એડમિન પેનલ (Admin Panel):*
    *   નવા લેસના ફોટા ઉમેરવા, એડિટ કરવા અને ડિલીટ કરવા.
    *   ગ્રાહકોની ઈન્ક્વાયરી (Inquiries) અને ઓર્ડર (Orders) જોવા, કન્ફર્મ કે કેન્સલ કરવા.
    *   WhatsApp નંબર અને એડમિન પાસવર્ડ બદલવાની સુવિધા.
    *   નવા ઓર્ડર આવે ત્યારે નોટિફિકેશન બેજ (1, 2, 3...) દેખાય છે.
*   *ગ્રાહક પેનલ (Customer Panel):*
    *   લેસના ફોટા અને તેની સંપૂર્ણ વિગતો જોવી.
    *   ગ્રાહક લોગિન / સાઇનઅપ (ઈમેલ/પાસવર્ડ).
    *   WhatsApp Inquiry અને Order કરવાની સુવિધા.
    *   પોતાના જ ઓર્ડર અને ઈન્ક્વાયરીની સ્થિતિ (Status) જોવી.
*   *UI/UX:* ડાર્ક મોડ અને લાઇટ મોડની સુવિધા.

## 🛠️ ટેક્નોલોજી સ્ટેક (Tech Stack)

*   *Frontend:* Flutter (Dart)
*   *Backend:* Firebase (Cloud Firestore)
*   *Authentication:* Firebase Auth (એડમિન અને ગ્રાહક માટે)
*   *State Management:* Provider
*   *Image Storage:* Base64 (ફોટા ડેટાબેઝમાં ટેક્સ્ટ સ્વરૂપે સેવ થાય છે)
*   *Other Packages:* image_picker, url_launcher, shared_preferences.

## 📁 ફોલ્ડર સ્ટ્રક્ચર (Folder Structure)

```text
lib/
├── main.dart                # એપનો પ્રારંભ (Firebase અને Provider સેટઅપ)
├── models/                  # ડેટા સ્ટ્રક્ચર (Lace, Inquiry, Order)
├── providers/               # સ્ટેટ મેનેજમેન્ટ (Auth, Theme, Lace, Order, Inquiry)
├── screens/                 
│   ├── admin/               # એડમિન પેનલની સ્ક્રીન્સ (Add, Edit, Orders, Inquiries)
│   ├── customer/            # ગ્રાહકની સ્ક્રીન્સ (Home, Detail, Auth, MyOrders)
│   ├── auth/                # એડમિન લોગિન
│   └── settings/            # સેટિંગ્સ અને હેલ્પ
├── services/                # ફાયરબેઝ અને લોકલ સ્ટોરેજ સર્વિસ
├── utils/                   # કલર્સ અને હેલ્પર ફાઈલ્સ
└── widgets/                 # રિયુઝેબલ વિજેટ્સ (TopBar, MenuPopup, Badge)
