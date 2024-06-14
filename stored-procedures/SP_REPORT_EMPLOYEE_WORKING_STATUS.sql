CREATE PROCEDURE SP_REPORT_EMPLOYEE_WORKING_STATUS
    @MANV INT,
    @FROM_DATE DATE,
    @TO_DATE DATE
AS
BEGIN
    SELECT
		PN.NGAY,
		PN.MAPN,
		'NHAP' AS LOAI_PHIEU,
		'NULL' AS KHACH_HANG,
		VT.TENVT,
		CTPN.SOLUONG,
		CTPN.DONGIA,
		TRI_GIA = CTPN.SOLUONG * CTPN.DONGIA
	INTO
		#DSPN
    FROM
        (SELECT PHIEUNHAP.NGAY, PHIEUNHAP.MAPN 
			FROM PHIEUNHAP 
			WHERE PHIEUNHAP.MANV = @MANV AND PHIEUNHAP.NGAY BETWEEN @FROM_DATE AND @TO_DATE
			) AS PN,
		CTPN,
		VATTU AS VT
	WHERE CTPN.MAPN = PN.MAPN AND VT.MAVT = CTPN.MAVT;

	SELECT
		PX.NGAY,
		PX.MAPX,
		'XUAT' AS LOAI_PHIEU,
		PX.HOTENKH AS KHACH_HANG,
		VT.TENVT,
		CTPX.SOLUONG,
		CTPX.DONGIA,
		TRI_GIA = CTPX.SOLUONG * CTPX.DONGIA
	INTO
		#DSPX
    FROM
        (SELECT PHIEUXUAT.NGAY, PHIEUXUAT.MAPX, PHIEUXUAT.HOTENKH
			FROM PHIEUXUAT 
			WHERE PHIEUXUAT.MANV = @MANV AND PHIEUXUAT.NGAY BETWEEN @FROM_DATE AND @TO_DATE
			) AS PX,
		CTPX,
		VATTU AS VT
	WHERE CTPX.MAPX = PX.MAPX AND VT.MAVT = CTPX.MAVT;

	SELECT * FROM #DSPN
	UNION
	SELECT * FROM #DSPX
	ORDER BY #DSPN.NGAY
END