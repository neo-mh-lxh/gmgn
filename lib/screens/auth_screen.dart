import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  final bool showCloseButton;

  const AuthScreen({
    super.key,
    this.showCloseButton = false,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // 注册步骤控制
  int _registerStep = 1; // 1: 邮箱, 2: 人机验证, 3: 验证码, 4: 设置密码
  bool _isHuman = false;
  String _verificationCode = '';
  Timer? _countdownTimer;
  int _countdown = 60;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  final _verificationCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 添加邮箱输入监听器，实时更新注册按钮状态
    _emailController.addListener(() {
      setState(() {});
    });
    // 添加验证码输入监听器，实时更新验证按钮状态
    _verificationCodeController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _inviteCodeController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: widget.showCloseButton
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: _isLogin ? _buildLoginPage() : _buildRegisterPage(),
      ),
    );
  }

  Widget _buildLoginPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: widget.showCloseButton ? 20 : 60),
          _buildLoginHeader(),
          const SizedBox(height: 40),
          _buildLoginForm(),
          const SizedBox(height: 16),
          _buildForgotPassword(),
          const SizedBox(height: 24),
          _buildSubmitButton(),
          const SizedBox(height: 24),
          _buildDivider(),
          const SizedBox(height: 24),
          _buildSocialLogins(),
          const SizedBox(height: 32),
          _buildWalletConnection(),
          const SizedBox(height: 40),
          _buildToggleAuth(),
          const SizedBox(height: 24),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildRegisterPage() {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: widget.showCloseButton ? 20 : 60),
              _buildRegisterHeader(),
              const SizedBox(height: 40),
              _buildRegisterContent(),
              const SizedBox(height: 40),
            ],
          ),
        ),
        if (widget.showCloseButton)
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
      ],
    );
  }

  Widget _buildRegisterHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '注册',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              '已有账号？',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade400,
              ),
            ),
            TextButton(
              onPressed: () => setState(() {
                _isLogin = true;
                _registerStep = 1;
              }),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                '去登录',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4ECCA3),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterContent() {
    switch (_registerStep) {
      case 1:
        return _buildEmailStep();
      case 2:
        return _buildHumanVerificationStep();
      case 3:
        return _buildVerificationCodeStep();
      case 4:
        return _buildPasswordStep();
      default:
        return _buildEmailStep();
    }
  }

  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '邮箱',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _emailController,
          hint: '输入邮箱',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: _inviteCodeController,
          hint: '邀请码（选填）',
        ),
        const SizedBox(height: 12),
        Text(
          '邀请码绑定后不可修改，请保证输入正确的邀请码',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 40),
        _buildRegisterButton(),
        const SizedBox(height: 32),
        _buildOtherRegisterMethods(),
        const SizedBox(height: 40),
        _buildFooter(),
      ],
    );
  }

  Widget _buildHumanVerificationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '人机验证',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade700),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.security,
                color: Color(0xFF4ECCA3),
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Google 人机验证',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '请完成人机验证以继续注册',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _isHuman,
                    onChanged: (value) =>
                        setState(() => _isHuman = value ?? false),
                    activeColor: const Color(0xFF4ECCA3),
                  ),
                  const Expanded(
                    child: Text(
                      '我不是机器人',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: _isHuman ? _proceedToVerificationCode : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4ECCA3),
            disabledBackgroundColor: Colors.grey.shade700,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            '继续',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _isHuman ? Colors.black : Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationCodeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '验证邮箱',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '验证码已发送到 ${_emailController.text}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          '验证码',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _verificationCodeController,
          hint: '输入6位验证码',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '没有收到验证码？',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
            TextButton(
              onPressed: _countdown > 0 ? null : _resendVerificationCode,
              child: Text(
                _countdown > 0 ? '重新发送 (${_countdown}s)' : '重新发送',
                style: TextStyle(
                  fontSize: 14,
                  color: _countdown > 0
                      ? Colors.grey.shade500
                      : const Color(0xFF4ECCA3),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed:
              _verificationCodeController.text.length == 6 ? _verifyCode : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4ECCA3),
            disabledBackgroundColor: Colors.grey.shade700,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            '验证',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _verificationCodeController.text.length == 6
                  ? Colors.black
                  : Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '设置密码',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            '密码',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          _buildPasswordField(
            controller: _passwordController,
            hint: '输入密码',
            obscureText: _obscurePassword,
            onVisibilityToggle: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 24),
          const Text(
            '确认密码',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          _buildPasswordField(
            controller: _confirmPasswordController,
            hint: '再次输入密码',
            obscureText: _obscureConfirmPassword,
            onVisibilityToggle: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _isLoading ? null : _completeRegistration,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4ECCA3),
              disabledBackgroundColor: Colors.grey.shade700,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                : const Text(
                    '完成注册',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback onVisibilityToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey.shade400,
            ),
            onPressed: onVisibilityToggle,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed:
          _emailController.text.isNotEmpty ? _proceedToHumanVerification : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4ECCA3),
        disabledBackgroundColor: Colors.grey.shade700,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        '注册',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _emailController.text.isNotEmpty
              ? Colors.black
              : Colors.grey.shade500,
        ),
      ),
    );
  }

  Widget _buildOtherRegisterMethods() {
    return Column(
      children: [
        Text(
          '其它注册方式',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialButton(
              iconData: Icons.telegram,
              iconColor: const Color(0xFF0088CC),
              label: 'Telegram',
              onTap: () {},
            ),
            _buildPhantomButton(
              label: 'Phantom',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData iconData,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade700),
            ),
            child: Center(
              child: Icon(
                iconData,
                size: 28,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhantomButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade700),
            ),
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9333EA), Color(0xFFB45AFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  // 注册流程方法
  void _proceedToHumanVerification() {
    if (_emailController.text.isEmpty) return;
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text)) {
      _showError('请输入有效的邮箱地址');
      return;
    }
    setState(() => _registerStep = 2);
  }

  void _proceedToVerificationCode() {
    // 模拟发送验证码
    _sendVerificationCode();
    setState(() => _registerStep = 3);
  }

  void _sendVerificationCode() {
    // 生成6位随机验证码
    final random = Random();
    _verificationCode = (100000 + random.nextInt(900000)).toString();
    _startCountdown();
    _showSuccess('验证码已发送到您的邮箱: $_verificationCode'); // 在实际应用中应该移除这行，这里只是为了测试方便
  }

  void _resendVerificationCode() {
    _sendVerificationCode();
  }

  void _verifyCode() {
    final inputCode = _verificationCodeController.text.trim();

    // 检查验证码格式
    if (inputCode.length != 6) {
      _showError('请输入6位验证码');
      return;
    }

    // 检查是否为纯数字
    if (!RegExp(r'^\d{6}$').hasMatch(inputCode)) {
      _showError('验证码必须为6位数字');
      return;
    }

    // 检查验证码是否正确
    if (inputCode == _verificationCode) {
      setState(() => _registerStep = 4);
    } else {
      _showError('验证码错误，请重新输入');
    }
  }

  void _startCountdown() {
    _countdown = 60;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _completeRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('两次密码输入不一致');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 使用邮箱前缀作为用户名
      final username = _emailController.text.split('@')[0];
      final result = await AuthService.register(
        username,
        _emailController.text,
        _passwordController.text,
      );

      if (result.isSuccess) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        _showError(result.error ?? '注册失败');
      }
    } catch (e) {
      _showError('注册失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 登录页面的原有方法保持不变
  Widget _buildLoginHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '登录',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildLoginTextField(
            controller: _emailController,
            label: '邮箱',
            hint: '输入邮箱',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty ?? true) return '邮箱不能为空';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value!)) {
                return '请输入有效的邮箱地址';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildLoginTextField(
            controller: _passwordController,
            label: '密码',
            hint: '输入密码',
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade400),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) return '密码不能为空';
              if (value!.length < 6) return '密码至少6个字符';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoginTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(icon, color: Colors.grey.shade400),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4ECCA3)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: 实现忘记密码功能
        },
        child: Text(
          '忘记密码？',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4ECCA3),
        disabledBackgroundColor: Colors.grey.shade700,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
          : const Text(
              '登录',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade700)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '或',
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildSocialLogins() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLoginSocialButton(
          iconData: Icons.telegram,
          iconColor: const Color(0xFF0088CC),
          label: 'Telegram',
          onPressed: () {},
        ),
        _buildLoginPhantomButton(
          label: 'Phantom',
          onPressed: () {},
        ),
        _buildLoginSocialButton(
          iconData: Icons.qr_code_scanner,
          iconColor: Colors.grey.shade300,
          label: 'APP扫码',
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSocialLoginButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.grey.shade300, size: 20),
          label: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 12,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            side: BorderSide(color: Colors.grey.shade700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginSocialButton({
    required IconData iconData,
    required Color iconColor,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            side: BorderSide(color: Colors.grey.shade700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, color: iconColor, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPhantomButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            side: BorderSide(color: Colors.grey.shade700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9333EA), Color(0xFFB45AFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletConnection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet, color: Colors.grey.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '连接插件钱包交易',
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 14,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
        ],
      ),
    );
  }

  Widget _buildToggleAuth() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '还没有账号？',
          style: TextStyle(color: Colors.grey.shade400),
        ),
        TextButton(
          onPressed: () => setState(() {
            _isLogin = false;
            _registerStep = 1;
          }),
          child: const Text(
            '立即注册',
            style: TextStyle(
              color: Color(0xFF4ECCA3),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            '服务条款',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ),
        Text(
          ' | ',
          style: TextStyle(color: Colors.grey.shade500),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            '隐私政策',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (result.isSuccess) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        _showError(result.error ?? '登录失败');
      }
    } catch (e) {
      _showError('登录失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }
}
