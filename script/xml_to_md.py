import os
import xml.etree.ElementTree as ElementTree
import re

LOCAL_ROOT = "."

# Don't create a link to these types because they're too boring.
PRIMITIVE_LIST = [
    "void",
    "null",
    "bool",
    "int",
    "float",
    "String",
    "StringName",
    "NodePath",
    "Variant",
]


def bbcode_to_markdown(text) -> str:
    text = text.strip()
    # Convert italic [i] to *italic*
    text = re.sub(r"\[i](.*?)\[/i]", r"*\1*", text)
    # Convert bold [b] to **bold**
    text = re.sub(r"\[b](.*?)\[/b]", r"**\1**", text)
    # Convert underlined [u] to <ins>underlined</ins>
    text = re.sub(r"\[u](.*?)\[/u]", r"<ins>\1</ins>", text)
    # Convert strikethrough [s] to ~~strikethrough~~
    text = re.sub(r"\[s](.*?)\[/s]", r"~~\1~~", text)
    # Convert code [code] to `code`, with inline highlight
    text = re.sub(r"\[code](.*?)\[/code]", r"`\1`", text)
    # Convert codeblock [codeblock] to triple backticks for code block
    # TODO support for lang= if we ever use it
    text = re.sub(
        r"\[codeblock](.*?)\[/codeblock]", r"```gdscript \1```", text, flags=re.DOTALL
    )
    # left and right brackets
    text = re.sub(r"\[lb]", r"[", text)
    text = re.sub(r"\[rb]", r"]", text)
    # Convert line breaks [br] to actual newlines
    text = re.sub(r"\[br]\[br]", r"\n\n", text)
    # Two spaces in front to make md break the line
    text = re.sub(r"\[br]", r"  \n", text)

    # formatting specific to how we add descriptions
    # convert these in descriptions to sub-headlines
    text = re.sub(r"\*\*Parameters:\*\*", r"#### Parameters:\n", text)
    text = re.sub(r"\*\*Returns:\*\*", r"**Returns:**\n", text)
    text = re.sub(r"\*\*Examples:\*\*", r"#### Examples:\n", text)

    # Admonitions (https://regex101.com/r/DIcJ9K/2)
    # everything between opening === and closing === is an admonition
    # the first line is always discarded in favor of the default titles
    # optional: the type/color can be changed and a custom title can be set
    # by using a (technically invalid but invisible) empty bbcode [color] tag
    # example:
    # ===[br]
    # [b]Note:[color=note "A note on paths"][/color][/b][br]
    # Your extender script doesn't have to follow the same directory path as the vanilla file,
    # but it's good practice to do so.[br]
    # ===[br]
    text = re.sub(
        r"===.*?\n(?:[^=]*?\[color=(?P<type>\w+)[^\"]*?(?P<title>\".*?\")?]|.*?$).*?\n(?P<body>.*?)===",
        md_format_admonition,
        text,
        flags=re.DOTALL | re.MULTILINE,
    )

    # colors
    text = re.sub(
        r"\[color=(.*?)](.*?)\[/color]",
        r'<span style="color: \1">\2</span>',
        text,
        flags=re.DOTALL,
    )

    # Linking to other documentation
    # Godot built in classes
    text = re.sub(
        r"\[(\w+?)]",
        lambda match: class_doc_link(class_name=match.group(1), item_type="class"),
        text,
    )

    re_classable = r"(\w*)\.?(\w*)"
    # References to methods in the same file into links
    text = re.sub(
        r"\[(method) " + re_classable + r"]",
        group_to_doclink,
        text,
    )

    # (\w*)\.?(\w*)
    # Constants as references
    text = re.sub(
        r"\[(constant) " + re_classable + r"]",
        group_to_doclink,
        text,
    )

    # Annotations as references
    text = re.sub(
        r"\[(annotation) " + re_classable + r"]",
        group_to_doclink,
        text,
    )

    # Members as references
    text = re.sub(
        r"\[(member) " + re_classable + r"]",
        group_to_doclink,
        text,
    )

    # Parameters are just like inline code
    text = re.sub(
        r"\[param (\w+?)]",
        lambda match: f"`{match.group(1)}`",
        text,
    )

    return text


def group_to_doclink(match: re.Match) -> str:
    if len(match.groups()) > 2 and len(match.group(3).strip()) > 0:
        return class_doc_link(match.group(2), match.group(3), match.group(1))
    return class_doc_link(item_name=match.group(2), item_type=match.group(1))


def md_format_admonition(match) -> str:
    admonition_type = match.group("type") or "note"
    title = match.group("title") or ""
    admonition_type = f"\n\n!!! {admonition_type} {title}\n"  # admonition syntax
    content = match.group("body")

    # Split the content into lines and add a tab indent to each line
    indented_content = "\n".join("\t" + line.strip() for line in content.splitlines())

    return admonition_type + indented_content + "\n"


def is_godot_engine(class_name: str = "") -> bool:
    return class_name != "" and class_name not in local_class_list


def class_doc_link(
    class_name: str = "", item_name: str = "", item_type: str = "method"
) -> str:
    if is_godot_engine(class_name):
        return godot_class_doc_link(class_name, item_name, item_type)
    return file_local_doc_link(class_name, item_name, item_type)


def file_local_doc_link(
    class_name: str = "", item_name: str = "", item_type: str = "method"
) -> str:
    anchor_text = ""
    anchor_url = ""

    if class_name:
        anchor_text += class_name
        anchor_url += f"{LOCAL_ROOT}/{pascal_to_snake_case(class_name)}.md"
        if item_name:
            anchor_text += "."
    if item_name:
        anchor_text += item_name
        anchor_url += f"#{item_name}"
    return f"[{anchor_text}]({anchor_url})"


def godot_class_doc_link(
    class_name: str | None = None,
    item_name: str | None = None,
    item_type: str = "method",
) -> str:
    if item_type == "member":
        item_type = "property"  # godot docs named it differently between url and xml for some reason

    anchor = ""
    if item_name is not None:
        anchor += f"#{item_type}-{item_name}"
    if class_name is None:  # local to script
        return anchor

    text_name = f"{class_name}"
    docs_link = f"https://docs.godotengine.org/en/stable/classes/class_{class_name.lower()}.html"
    if item_name:
        url_item_name = item_name.replace("_", "-")
        docs_link += f"#class-{class_name.lower()}-{item_type}-{url_item_name.lower()}"
        text_name += f".{item_name}"
    return f"[{text_name}]({docs_link})"


def formatted_class_doc_link(class_name: str = "") -> str:
    return class_doc_link(class_name)


def create_anchor(name: str = "") -> str:
    return f" <a id='{name}'></a>\n"


def create_sep() -> str:
    return "\n---\n"


# Function to convert XML to Markdown
def xml_to_markdown(xml_string):
    # Parse the XML
    root = ElementTree.fromstring(xml_string)

    # Extract class information
    class_name = root.get("name")
    inherits = class_doc_link(root.get("inherits") or "")

    md = ""

    md += f"# {class_name}\n\n"
    md += f"**Inherits**: {inherits}\n"

    # Process brief description
    brief_desc = root.find("brief_description")

    if brief_desc is not None:
        md += f"\n{bbcode_to_markdown(brief_desc.text)}\n"

    # Process detailed description
    description = root.find("description")
    if (
        description is not None
        and description.text is not None
        and description.text.strip()
    ):
        md += f"## Description\n{bbcode_to_markdown(description.text)}\n\n"
    md += create_sep()  # <hr style="border-width: thick">\n\n'

    tutorials = root.find("tutorials")
    if tutorials is not None and len(tutorials.findall("tutorial")) > 0:
        md += "## Tutorials\n"
        for link in tutorials.findall("link"):
            title = link.get("title")
            url = link.text
            md += f"- [{title}]({url})\n"
        md += create_sep()  # '<hr style="border-width: thick">\n'

    constants_md = get_variable_markdown(root, "constants", "constant")
    if constants_md is not None:
        md += "## Constants\n"
        md += constants_md

    properties_md = get_variable_markdown(root, "members", "member")
    if properties_md is not None:
        md += "## Properties\n"
        md += properties_md

    md += "## Method Descriptions\n"
    methods = root.findall("methods/method")
    for method in methods:
        method_name = method.get("name")
        if method_name is None or method_name.startswith("_"):
            continue

        # Return type
        returns = method.find("return")
        return_text = formatted_class_doc_link("Variant")
        if returns is not None:
            return_type = returns.get("type")
            if return_type is None:
                return_text = "`void`"
            elif return_type in PRIMITIVE_LIST:
                return_text = f"`{return_type}`"
            else:
                return_text = formatted_class_doc_link(return_type)

        # static
        qualifiers = method.get("qualifiers", "")
        if qualifiers:
            qualifiers = f"`{qualifiers}` "

        # Parameters
        params = method.findall("param")
        param_separator = "`, ` "
        params_text = ""
        if params:
            for param in params:
                param_name = param.get("name")
                param_type = param.get("type")
                if param_type is None:
                    params_text += (
                        f"`{param_name}:`&nbsp;&nbsp;UNKNOWN{param_separator}"
                    )
                    continue
                if param_type in PRIMITIVE_LIST:
                    params_text += (
                        f"`{param_name}:`&nbsp;&nbsp;`{param_type}` {param_separator}"
                    )
                else:
                    params_text += f"`{param_name}:`&nbsp;&nbsp;{formatted_class_doc_link(param_type)}{param_separator}"
            params_text = params_text.removesuffix(param_separator)

        md += (
            f"### • {qualifiers}{return_text}&nbsp;&nbsp;`{method_name}(` {params_text}`)`"
            # attribute list extension at the end
            # to prefix the anchor with "method-", clean the table of contents, and remove awkward spacing
            f" {create_anchor(method_name)}\n"
        )

        description = method.find("description")
        if (
            description is not None
            and description.text is not None
            and description.text.strip()
        ):
            md += f"#### Description:\n{bbcode_to_markdown(description.text)}\n"

        # Separate methods by a line break
        md += "***\n"

    return md


def get_variable_markdown(xml_root, group_name, item_type):
    group = xml_root.find(group_name)
    if group is None:
        return None

    md = ""
    for item in group.findall(item_type):
        name = item.get("name")
        if name.startswith("_"):
            continue
        value = item.get("value")
        md += f"#### • `{name}`"
        if value is not None:
            md += f": `{value}`"
        md += f"{create_anchor(name)}\n"
        md += bbcode_to_markdown(item.text)
        md += "\n"
    md += f"\n{create_sep()}\n\n"
    return md


# Read XML from a file and write Markdown to another file
def convert_file_to_markdown(input_file_path, output_file_path):
    print(f"Processing {input_file_path} -> {output_file_path}")
    # Read XML content from the input file
    with open(input_file_path, "r", encoding="utf-8") as input_file:
        xml_content = input_file.read()

    # Convert XML to Markdown
    markdown_content = xml_to_markdown(xml_content)

    # Write the Markdown content to the output file
    with open(output_file_path, "w", encoding="utf-8") as output_file:
        output_file.write(markdown_content)


def pascal_to_snake_case(text: str) -> str:
    return re.sub(r"(?<!^)(?=[A-Z])", "_", text).lower()


current_class = ""

local_class_list = []

if __name__ == "__main__":
    xml_path = "doc_classes"
    md_path = "docs/api"

    # Make the local local_class_list
    for file in os.listdir(xml_path):
        if not file.endswith(".xml"):
            continue

        with open(f"{xml_path}/{file}", "r", encoding="utf-8") as input_file:
            xml_content = input_file.read()

            # Parse the XML
            root = ElementTree.fromstring(xml_content)

            # Extract class information
            class_name = root.get("name")
            if not class_name:
                continue
            local_class_list.append(root.get("name"))

    print(f"Classes: {local_class_list}")
    # process all in the folder
    for file in os.listdir(xml_path):
        if not file.endswith(".xml"):
            continue

        filename = file.removesuffix(".xml")
        # ignore inner classes
        if "." in filename:
            filename = filename.split(".", 1)[-1]

        convert_file_to_markdown(
            f"{xml_path}/{file}", f"{md_path}/{pascal_to_snake_case(filename)}.md"
        )
