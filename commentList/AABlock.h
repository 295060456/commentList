typedef void(^KBlock)(id data,...);
typedef void(^NoResultBlock)(void);
typedef void(^MKDataBlock)(id data);
typedef void(^TwoDataBlock)(id data,id data2);
typedef void(^ThreeDataBlock)(id data,id data2,id data3);
typedef void(^FourDataBlock)(id data,id data2,id data3,id data4);
typedef void(^FiveDataBlock)(id data,id data2,id data3,id data4,id data5);
typedef void(^SixDataBlock)(id data,id data2,id data3,id data4,id data5,id data6);
typedef void(^SevenDataBlock)(id data,id data2,id data3,id data4,id data5,id data7);
typedef void(^EightDataBlock)(id data,id data2,id data3,id data4,id data5,id data7,id data8);
typedef void(^NineDataBlock)(id data,id data2,id data3,id data4,id data5,id data7,id data8,id data9);
typedef void(^TenDataBlock)(id data,id data2,id data3,id data4,id data5,id data7,id data8,id data9,id data10);
typedef void(^MMDataBlock)(id firstArg,...);//第一个参数写：有多少个实际参数 用NSNumber表示 @1
