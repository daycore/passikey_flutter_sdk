//
//  PassikeyErrorCode.h
//  PASSIKEYauth
//
//  Created by Kim Min joung on 26/03/2020.
//  Copyright © 2020 ROWEM. All rights reserved.
//



typedef enum
{
    PASSIKEY_SUCCESS = 0000 ,                        // 성공
    
    // Passikey Server response
    
    
    // Library internal response
    
    // 개발자 센터에 등록되지 않은 애플리케이션.
    PASSIKEY_FAIL_NOT_REGIST_CLIENT_ID = -1000,
    
    NOT_INSTALL_PASSIKEY = 1001,
        
    //사용자 취소 - 전체
    USER_CANCEL = 8000,
    
    //SDK 내부 오류 - 공통
    CLIENT_ERROR = 8001,
    
    //PASSIKEY Server 오류 - 공통
    SERVER_ERROR = 8002,
    
    //통신 오류 - 공통
    NETWORK_ERROR = 8003,
    
    // 발급되지 않은 시크릿 키. 클라이언트 ID, 시크릿 키 검증 실패 - SDK 내부
    INVALID_CONFIG_INFO = 8010,
    
    //PackageName/BundleId, KeyHash등 앱 정보 검증 오류 - SDK 내부
    INVALID_APPLICATION_INFO = 8011,
    
    //상태 토큰 오류
    INVALID_STATE_TOKEN = 8012,
    
    //로그인 API 설정 미완료
    NOT_SUPPORT_LOGIN = 8013,
    
    INVALID_SCHEME = 8014,
    
    //로그인중 오류 발생  - PASSIKEY 앱
    LOGIN_FAILED = 8020,
    
    // PASSIKEY App 미설치.
    PASSIKEY_FAIL_NOT_INSTALL_PASSIKEY = -1005,
    
    UNKOWN_ERR = 9999,
    

} passikeyRespCode;
