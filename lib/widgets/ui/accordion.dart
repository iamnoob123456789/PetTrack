// Enhanced accordion with more Radix-like features
class AdvancedAccordion extends StatefulWidget {
  final List<AccordionItem> children;
  final bool allowMultipleExpansion;
  final int? initiallyOpenIndex;
  final ValueChanged<String?>? onValueChange;
  final String? value;

  const AdvancedAccordion({
    super.key,
    required this.children,
    this.allowMultipleExpansion = false,
    this.initiallyOpenIndex,
    this.onValueChange,
    this.value,
  });

  @override
  State<AdvancedAccordion> createState() => _AdvancedAccordionState();
}

class _AdvancedAccordionState extends State<AdvancedAccordion> {
  late List<bool> _isOpenList;

  @override
  void initState() {
    super.initState();
    _isOpenList = List.filled(widget.children.length, false);
    
    // Set initially open item
    if (widget.initiallyOpenIndex != null && 
        widget.initiallyOpenIndex! < widget.children.length) {
      _isOpenList[widget.initiallyOpenIndex!] = true;
    }
  }

  void _toggleItem(int index) {
    setState(() {
      final newValue = !_isOpenList[index];
      
      if (!widget.allowMultipleExpansion && newValue) {
        // Close all other items
        for (int i = 0; i < _isOpenList.length; i++) {
          _isOpenList[i] = i == index;
        }
      } else {
        _isOpenList[index] = newValue;
      }
      
      // Notify value change
      if (newValue && widget.children[index].value != null) {
        widget.onValueChange?.call(widget.children[index].value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < widget.children.length; i++)
          _buildAccordionItem(i),
      ],
    );
  }

  Widget _buildAccordionItem(int index) {
    final item = widget.children[index];
    
    return Container(
      decoration: BoxDecoration(
        border: index == widget.children.length - 1
            ? null
            : const Border(
                bottom: BorderSide(
                  color: Color(0x14000000),
                  width: 1,
                ),
              ),
      ),
      child: Column(
        children: [
          // Trigger
          _AccordionTrigger(
            isOpen: _isOpenList[index],
            onTap: () => _toggleItem(index),
            child: item.trigger,
          ),
          // Content with animation
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _isOpenList[index]
                ? _AccordionContent(
                    child: item.content,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _AccordionTrigger extends StatelessWidget {
  final Widget child;
  final bool isOpen;
  final VoidCallback onTap;

  const _AccordionTrigger({
    required this.child,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: child),
              const SizedBox(width: 16),
              AnimatedRotation(
                turns: isOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccordionContent extends StatelessWidget {
  final Widget child;

  const _AccordionContent({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: child,
    );
  }
}