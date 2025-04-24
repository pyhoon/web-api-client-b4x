# Web API Client
**Latest Version: 2.00**

Web API Client native apps for Mobile (Android and iOS) and Desktop (Windows, Linux and macOS)

Demonstrate how to communicate with [Web API Server](https://github.com/pyhoon/web-api-server-b4j)


## Version compatibility:

Version 2.00: Web API Server 3.50

Version 1.05: Web API Server 1.16, Web API Server 2.08

## Depends on following libraries: 

**B4A:** B4XPages 1.10+, B4XPreferencesDialog 1.73+, Core 11.00+, OkHttpUtils2 2.96+, XUI Views 2.52+

**B4i:** B4XPages 1.10+, B4XPreferencesDialog 1.73+, iCore 7.01+, iHttpUtils2 2.96+, XUI Views 2.52+

**B4J:** B4XPages 1.10+, B4XPreferencesDialog 1.73+, jCore 9.10+, jOkHttpUtils2 2.96+, XUI Views 2.52+, jFX 9.00+

## Features:
- CRUD based (CREATE, READ, UPDATE, DELETE)
- B4XPages
- B4X Sliding menu
- B4X CustomListView
- B4X Loading indicator
- B4X PreferencesDialog

## How to run:
1. Download the project template "Web API Client (x.xx).b4xtemplate"
2. Copy to B4X Additional Libraries directory
3. Open either B4A, B4i or B4J IDE (recommended to start with B4J)
4. Click the IDE menu File -> New -> Web API Client (x.xx)
5. Create a new project with any name you like
6. Edit the URL (in B4XMainPage module line #11) to point to your Web API server address
```basic
' Version 1.x
Private URL As String = "http://192.168.50.42:19800/v1/"

' Version 2.x
Private URL As String = "http://192.168.50.42:8080/api/"
```
7. Start Web API Server project in Release mode
8. Run the client project in Debug mode

**Preview:**

<img src="https://github.com/pyhoon/webapi-client-b4x/raw/main/Preview/B4A.png" title="B4A" />
<img src="https://github.com/pyhoon/webapi-client-b4x/raw/main/Preview/B4i.png" title="B4i" />
<img src="https://github.com/pyhoon/webapi-client-b4x/raw/main/Preview/B4J.png" title="B4J" />
<img src="https://github.com/pyhoon/webapi-client-b4x/raw/main/Preview/ubuntu-desktop.png" title="Linux" />

**YouTube:**

[![Alt text](https://img.youtube.com/vi/3wydFKQmbp0/0.jpg)](https://youtu.be/3wydFKQmbp0)

[![Alt text](https://img.youtube.com/vi/YplEEQhUQ4Q/0.jpg)](https://youtu.be/YplEEQhUQ4Q)

[![Alt text](https://img.youtube.com/vi/p6d4P5tT6_0/0.jpg)](https://youtu.be/p6d4P5tT6_0)

Made with ❤ in B4X

Download and Develop with **[B4A](https://www.b4x.com/b4a.html)** for FREE \
Download and Develop with **[B4J](https://www.b4x.com/b4j.html)** for FREE \
Download and Develop with **[B4i](https://www.b4x.com/b4i.html)** without using Mac
