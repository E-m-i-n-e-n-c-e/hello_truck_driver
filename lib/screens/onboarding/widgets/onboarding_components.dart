import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';

class OnboardingStepContainer extends StatelessWidget {
  final OnboardingController controller;
  final Widget child;

  const OnboardingStepContainer({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.fadeAnimation,
      builder: (context, _) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: SlideTransition(
            position: controller.slideAnimation,
            child: ScaleTransition(
              scale: controller.scaleAnimation,
              child: Padding(padding: const EdgeInsets.all(24.0), child: child),
            ),
          ),
        );
      },
    );
  }
}

class OnboardingStepIcon extends StatelessWidget {
  final OnboardingController controller;
  final IconData icon;
  final Color? color;

  const OnboardingStepIcon({
    super.key,
    required this.controller,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: controller.scaleAnimation,
      builder: (context, _) {
        return Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color ?? colorScheme.secondary,
                  (color ?? colorScheme.secondary).withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: (color ?? colorScheme.secondary).withValues(
                    alpha: 0.3,
                  ),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, size: 36, color: colorScheme.onSecondary),
          ),
        );
      },
    );
  }
}

class OnboardingStepTitle extends StatelessWidget {
  final OnboardingController controller;
  final String title;

  const OnboardingStepTitle({
    super.key,
    required this.controller,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: controller.fadeAnimation,
      builder: (context, _) {
        return Text(
          title,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}

class OnboardingStepDescription extends StatelessWidget {
  final OnboardingController controller;
  final String description;

  const OnboardingStepDescription({
    super.key,
    required this.controller,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: controller.fadeAnimation,
      builder: (context, _) {
        return Text(
          description,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}

class OnboardingTextField extends StatefulWidget {
  final OnboardingController controller;
  final TextEditingController textController;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final IconData icon;
  final bool isRequired;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String)? onSubmitted;
  final int maxLines;
  final String? prefixText;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const OnboardingTextField({
    super.key,
    required this.controller,
    required this.textController,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
    this.isRequired = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onSubmitted,
    this.maxLines = 1,
    this.prefixText,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  State<OnboardingTextField> createState() => _OnboardingTextFieldState();
}

class _OnboardingTextFieldState extends State<OnboardingTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _focusAnimationController;
  late Animation<double> _focusAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusAnimation = CurvedAnimation(
      parent: _focusAnimationController,
      curve: Curves.easeInOut,
    );

    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    _focusAnimationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = widget.focusNode.hasFocus;
      if (_isFocused) {
        _focusAnimationController.forward();
      } else {
        _focusAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: widget.controller.slideAnimation,
      builder: (context, _) {
        return AnimatedBuilder(
          animation: _focusAnimation,
          builder: (context, _) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: colorScheme.secondary.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: TextFormField(
                controller: widget.textController,
                focusNode: widget.focusNode,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                inputFormatters: widget.inputFormatters,
                onFieldSubmitted: widget.onSubmitted,
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hint,
                  prefixText: widget.prefixText,
                  prefixIcon: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      widget.icon,
                      color: _isFocused
                          ? colorScheme.secondary
                          : colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  suffixIcon: widget.isRequired
                      ? Icon(Icons.star, size: 8, color: colorScheme.error)
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colorScheme.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colorScheme.error, width: 2),
                  ),
                  filled: true,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class OnboardingDropdown extends StatefulWidget {
  final OnboardingController controller;
  final String label;
  final IconData icon;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final Function(String?) onChanged;

  const OnboardingDropdown({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  State<OnboardingDropdown> createState() => _OnboardingDropdownState();
}

class _OnboardingDropdownState extends State<OnboardingDropdown> {
  OverlayEntry? dropdownOverlay;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    dropdownOverlay?.remove();
    _focusNode.dispose();
    super.dispose();
  }

  String _extractTextFromDropdownItem(DropdownMenuItem<String> item) {
    if (item.child is Text) {
      return (item.child as Text).data ?? '';
    } else if (item.child is String) {
      return item.child as String;
    }
    return item.child.toString();
  }

  void _showDropdownMenu(BuildContext context) {
    if (widget.items.isEmpty) return;

    final RenderBox buttonBox = context.findRenderObject() as RenderBox;
    final Offset buttonPosition = buttonBox.localToGlobal(Offset.zero);
    final Size buttonSize = buttonBox.size;
    const double itemHeight = 48.0;
    const double maxHeight = 200.0;
    final double calculatedHeight = (widget.items.length * itemHeight).clamp(0.0, maxHeight);

    dropdownOverlay?.remove();
    final ScrollController scrollController = ScrollController();

    dropdownOverlay = OverlayEntry(
      builder: (overlayContext) {
        return Stack(
          children: [
            // Transparent overlay to handle taps outside
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  dropdownOverlay?.remove();
                  dropdownOverlay = null;
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // Dropdown menu
            Positioned(
              left: buttonPosition.dx,
              top: buttonPosition.dy + buttonSize.height*0.9, // Moved up by 4 pixels
              width: buttonSize.width,
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  constraints: BoxConstraints(maxHeight: calculatedHeight),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      scrollbars: false,
                    ),
                    child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: widget.items.length,
                      itemExtent: itemHeight,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        final isSelected = item.value == widget.value;

                        return InkWell(
                          onTap: () {
                            dropdownOverlay?.remove();
                            dropdownOverlay = null;
                            widget.onChanged(item.value);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            width: double.infinity,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                                : null,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _extractTextFromDropdownItem(item),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isSelected
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.onSurface,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(dropdownOverlay!);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    String displayText;

    if (widget.value == null || widget.value!.isEmpty) {
      displayText = 'Select ${widget.label.toLowerCase()}';
    } else {
      final selectedItem = widget.items.firstWhere(
        (item) => item.value == widget.value,
        orElse: () => widget.items.first,
      );
      displayText = _extractTextFromDropdownItem(selectedItem);
    }

    return AnimatedBuilder(
      animation: widget.controller.slideAnimation,
      builder: (context, _) {
        return GestureDetector(
          onTap: () => _showDropdownMenu(context),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              color: colorScheme.surface,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          displayText,
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.value == null || widget.value!.isEmpty
                                ? colorScheme.onSurface.withValues(alpha: 0.5)
                                : colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class OnboardingNote extends StatelessWidget {
  final String note;

  const OnboardingNote({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return       // Note about electricity bill
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    note,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}