CREATE DATABASE  sportzonevn 
USE sportzonevn;


-- Bảng thương hiệu
CREATE TABLE ThuongHieu (
  MaThuongHieu INT IDENTITY(1,1) PRIMARY KEY,
  TenThuongHieu NVARCHAR(150),
  MoTa NVARCHAR(MAX),
  Website NVARCHAR(255)
);

-- Bảng danh mục
CREATE TABLE DanhMuc (
  MaDanhMuc INT IDENTITY(1,1) PRIMARY KEY,
  TenDanhMuc NVARCHAR(150),
  MoTa NVARCHAR(MAX),
  NgayTao DATETIME DEFAULT GETDATE(),
  NgayCapNhat DATETIME DEFAULT GETDATE()
);

-- Nhà cung cấp
CREATE TABLE NhaCungCap (
  MaNCC INT IDENTITY(1,1) PRIMARY KEY,
  TenNCC NVARCHAR(200),
  NguoiLienHe NVARCHAR(150),
  SDT NVARCHAR(30),
  Email NVARCHAR(150),
  DiaChi NVARCHAR(MAX),
  GhiChu NVARCHAR(MAX)
);

-- Cửa hàng
CREATE TABLE CuaHang (
  MaCuaHang INT IDENTITY(1,1) PRIMARY KEY,
  TenCuaHang NVARCHAR(200),
  DiaChi NVARCHAR(MAX),
  SDT NVARCHAR(30),
  GioMoCua NVARCHAR(100),
  TrangThaiHoatDong BIT DEFAULT 1
);

-- Khách hàng
CREATE TABLE KhachHang (
  MaKhachHang INT IDENTITY(1,1) PRIMARY KEY,
  HoTen NVARCHAR(200),
  Email NVARCHAR(150),
  SDT NVARCHAR(30)
);

-- Địa chỉ
CREATE TABLE DiaChi (
  MaDiaChi INT IDENTITY(1,1) PRIMARY KEY,
  DiaChi NVARCHAR(MAX),
  ThanhPho NVARCHAR(100),
  Tinh NVARCHAR(100),
  QuocGia NVARCHAR(100),
  MaKhachHang INT FOREIGN KEY REFERENCES KhachHang(MaKhachHang)
);

-- Vai trò & quyền
CREATE TABLE VaiTro (
  MaVaiTro INT IDENTITY(1,1) PRIMARY KEY,
  TenVaiTro NVARCHAR(150)
);

CREATE TABLE Quyen (
  MaQuyen INT IDENTITY(1,1) PRIMARY KEY,
  TenQuyen NVARCHAR(150)
);

CREATE TABLE VaiTro_Quyen (
  MaQuyen INT FOREIGN KEY REFERENCES Quyen(MaQuyen),
  MaVaiTro INT FOREIGN KEY REFERENCES VaiTro(MaVaiTro),
  PRIMARY KEY (MaQuyen, MaVaiTro)
);

-- Tài khoản
CREATE TABLE TaiKhoan (
  MaTK INT IDENTITY(1,1) PRIMARY KEY,
  TenDangNhap NVARCHAR(100) UNIQUE,
  MatKhau NVARCHAR(255),
  Email NVARCHAR(150),
  TrangThaiHoatDong BIT DEFAULT 1,
  NgayTao DATETIME DEFAULT GETDATE(),
  NgayCapNhat DATETIME DEFAULT GETDATE(),
  MaVaiTro INT FOREIGN KEY REFERENCES VaiTro(MaVaiTro)
);

-- Sản phẩm
CREATE TABLE SanPham (
  MaSanPham INT IDENTITY(1,1) PRIMARY KEY,
  MaSKU NVARCHAR(100),
  TenSanPham NVARCHAR(255),
  MoTa NVARCHAR(MAX),
  GiaBan DECIMAL(12,2) DEFAULT 0,
  GiaVon DECIMAL(12,2) DEFAULT 0,
  TrangThai BIT DEFAULT 1,
  NgayTao DATETIME DEFAULT GETDATE(),
  NgayCapNhat DATETIME DEFAULT GETDATE(),
  MaThuongHieu INT FOREIGN KEY REFERENCES ThuongHieu(MaThuongHieu)
);

-- Sản phẩm - Danh mục
CREATE TABLE SanPhamDanhMuc (
  MaDanhMuc INT FOREIGN KEY REFERENCES DanhMuc(MaDanhMuc),
  MaSanPham INT FOREIGN KEY REFERENCES SanPham(MaSanPham),
  MaThuongHieu INT FOREIGN KEY REFERENCES ThuongHieu(MaThuongHieu),
  PRIMARY KEY (MaDanhMuc, MaSanPham)
);

-- Hình ảnh sản phẩm
CREATE TABLE HinhAnhSanPham (
  MaHinhAnh INT IDENTITY(1,1) PRIMARY KEY,
  URL NVARCHAR(300),
  VanBanThayThe NVARCHAR(255),
  ThuTuHienThi INT DEFAULT 0,
  MaSanPham INT FOREIGN KEY REFERENCES SanPham(MaSanPham),
  MaThuongHieu INT FOREIGN KEY REFERENCES ThuongHieu(MaThuongHieu)
);

-- Thuộc tính sản phẩm
CREATE TABLE ThuocTinhSanPham (
  MaThuocTinh INT IDENTITY(1,1) PRIMARY KEY,
  Size NVARCHAR(50),
  MauSac NVARCHAR(100),
  TrangThaiHoatDong BIT DEFAULT 1,
  MaSanPham INT FOREIGN KEY REFERENCES SanPham(MaSanPham),
  MaThuongHieu INT FOREIGN KEY REFERENCES ThuongHieu(MaThuongHieu)
);

-- Đơn nhập hàng
CREATE TABLE DonNhapHang (
  MaDonNhap INT IDENTITY(1,1) PRIMARY KEY,
  NgayGiaoDuKien DATE,
  TrangThai NVARCHAR(50),
  TongTien DECIMAL(12,2) DEFAULT 0,
  MaNCC INT FOREIGN KEY REFERENCES NhaCungCap(MaNCC)
);

-- Khuyến mãi
CREATE TABLE KhuyenMai (
  MaKhuyenMai INT IDENTITY(1,1) PRIMARY KEY,
  Code NVARCHAR(100) UNIQUE,
  LoaiGiam NVARCHAR(50),
  GiaTri DECIMAL(12,2),
  DonToiThieu DECIMAL(12,2),
  NgayBatDau DATE,
  NgayKetThuc DATE,
  GioiHanSuDung INT,
  GioiHanMoiKhach INT,
  TrangThai BIT DEFAULT 1
);

-- Đơn hàng
CREATE TABLE DonHang (
  MaDonHang INT IDENTITY(1,1) PRIMARY KEY,
  SoDonHang NVARCHAR(100),
  TongTien DECIMAL(12,2) DEFAULT 0,
  PhiVanChuyen DECIMAL(12,2) DEFAULT 0,
  GiamGia DECIMAL(12,2) DEFAULT 0,
  TrangThai NVARCHAR(50),
  NgayDat DATETIME DEFAULT GETDATE(),
  MaKhachHang INT FOREIGN KEY REFERENCES KhachHang(MaKhachHang)
);

-- Chi tiết đơn hàng
CREATE TABLE ChiTietDonHang (
  MaChiTietDonHang INT IDENTITY(1,1) PRIMARY KEY,
  SoLuong INT DEFAULT 1,
  DonGia DECIMAL(12,2) DEFAULT 0,
  ThanhTien AS (SoLuong * DonGia) PERSISTED,
  MaSanPham INT FOREIGN KEY REFERENCES SanPham(MaSanPham),
  MaThuongHieu INT FOREIGN KEY REFERENCES ThuongHieu(MaThuongHieu),
  MaDonHang INT FOREIGN KEY REFERENCES DonHang(MaDonHang),
  MaKhachHang INT FOREIGN KEY REFERENCES KhachHang(MaKhachHang),
  MaThuocTinh INT FOREIGN KEY REFERENCES ThuocTinhSanPham(MaThuocTinh)
);

-- Giao hàng
CREATE TABLE GiaoHang (
  MaGiaoHang INT IDENTITY(1,1) PRIMARY KEY,
  DonViVanChuyen NVARCHAR(200),
  MaVanDon NVARCHAR(200),
  TrangThai NVARCHAR(50),
  NgayGui DATETIME,
  NgayGiao DATETIME,
  MaDonHang INT FOREIGN KEY REFERENCES DonHang(MaDonHang),
  MaKhachHang INT FOREIGN KEY REFERENCES KhachHang(MaKhachHang)
);

-- Thanh toán
CREATE TABLE ThanhToan (
  MaThanhToan INT IDENTITY(1,1) PRIMARY KEY,
  PhuongThuc NVARCHAR(100),
  TrangThai NVARCHAR(50),
  SoTien DECIMAL(12,2) DEFAULT 0,
  MaGiaoDich NVARCHAR(200),
  NgayThanhToan DATETIME,
  MaDonHang INT FOREIGN KEY REFERENCES DonHang(MaDonHang),
  MaKhachHang INT FOREIGN KEY REFERENCES KhachHang(MaKhachHang)
);

-- Giỏ hàng
CREATE TABLE GioHang (
  MaGioHang INT IDENTITY(1,1) PRIMARY KEY,
  NgayTao DATETIME DEFAULT GETDATE(),
  NgayCapNhat DATETIME DEFAULT GETDATE(),
  MaKhachHang INT FOREIGN KEY REFERENCES KhachHang(MaKhachHang)
);