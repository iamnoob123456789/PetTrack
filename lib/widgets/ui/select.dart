import 'package:flutter/material.dart';

class Select extends StatefulWidget {
  final String? value;
  final List<SelectItem> items;
  final ValueChanged<String?> onChanged;
  final String? placeholder;
  final bool enabled;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double borderRadius;

  const Select({
    super.key,
    this.value,
    required this.items,
    required this.onChanged,
    this.placeholder,
    this.enabled = true,
    this.width = double.infinity,
    this.height = 36,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.borderRadius = 8,
  });

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();

  void _showOverlay() {
    if (!widget.enabled) return;

    final renderBox = _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;
    final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _hideOverlay,
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: offset.dy + size.height + 4,
                width: size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0, size.height + 4),
                  child: _buildDropdownContent(size.width),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleItemSelect(String value) {
    widget.onChanged(value);
    _hideOverlay();
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedItem = widget.items.firstWhere(
      (item) => item.value == widget.value,
      orElse: () => SelectItem(value: '', label: widget.placeholder ?? 'Select...'),
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _showOverlay,
        child: Container(
          key: _triggerKey,
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? theme.colorScheme.surface,
            border: Border.all(
              color: widget.borderColor ?? theme.colorScheme.outline.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedItem.label,
                  style: TextStyle(
                    color: widget.textColor ?? theme.colorScheme.onSurface,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownContent(double width) {
    final theme = Theme.of(context);
    
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        constraints: const BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(4),
          shrinkWrap: true,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final isSelected = item.value == widget.value;
            
            return _SelectItem(
              item: item,
              isSelected: isSelected,
              onTap: () => _handleItemSelect(item.value),
            );
          },
        ),
      ),
    );
  }
}

class _SelectItem extends StatelessWidget {
  final SelectItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected 
                ? theme.colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectItem {
  final String value;
  final String label;
  final Widget? icon;

  const SelectItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

// Simplified version for common use cases
class SimpleSelect extends StatelessWidget {
  final String? value;
  final Map<String, String> options;
  final ValueChanged<String?> onChanged;
  final String? placeholder;
  final bool enabled;

  const SimpleSelect({
    super.key,
    this.value,
    required this.options,
    required this.onChanged,
    this.placeholder,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final items = options.entries
        .map((entry) => SelectItem(value: entry.key, label: entry.value))
        .toList();

    return Select(
      value: value,
      items: items,
      onChanged: onChanged,
      placeholder: placeholder,
      enabled: enabled,
    );
  }
}

// Select with form field capabilities
class SelectFormField extends FormField<String> {
  SelectFormField({
    super.key,
    super.initialValue,
    super.validator,
    super.autovalidateMode,
    super.enabled,
    required List<SelectItem> items,
    String? placeholder,
    ValueChanged<String?>? onChanged,
  }) : super(
          builder: (FormFieldState<String> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Select(
                  value: field.value,
                  items: items,
                  onChanged: enabled ?? true
                      ? (value) {
                          field.didChange(value);
                          onChanged?.call(value);
                        }
                      : null,
                  placeholder: placeholder,
                  enabled: enabled ?? true,
                ),
                if (field.hasError) ...[
                  const SizedBox(height: 4),
                  Text(
                    field.errorText!,
                    style: TextStyle(
                      color: Theme.of(field.context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            );
          },
        );